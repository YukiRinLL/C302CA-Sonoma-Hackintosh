$ErrorActionPreference = 'Stop'
$log = 'E:\hackintosh\hfsimg\rebuild_log.txt'
function Log($m){ $t=Get-Date -Format 'HH:mm:ss'; Add-Content $log "$t $m"; Write-Host "$t $m" }
Set-Content $log "=== U盘重建开始 $(Get-Date) ==="

try {
    # ===== 0. 身份核验：只允许磁盘2 / USB / 55-65GB =====
    $d = Get-Disk -Number 2
    Log("目标: Disk$($d.Number) '$($d.FriendlyName)' $([math]::Round($d.Size/1GB,1))GB Bus=$($d.BusType) 样式=$($d.PartitionStyle)")
    if ($d.BusType -ne 'USB') { Log('ABORT: 磁盘2不是USB总线'); exit 1 }
    if ($d.Size -lt 55GB -or $d.Size -gt 65GB) { Log("ABORT: 容量异常 $($d.Size)"); exit 1 }

    $srcHfs = 'E:\hackintosh\hfsimg\4.hfs'
    $srcEfi = 'E:\hackintosh\efi-build\EFI\EFI'
    $hfsLen = (Get-Item $srcHfs).Length
    $srcHash = (Get-FileHash $srcHfs -Algorithm SHA256).Hash
    Log("镜像: $hfsLen 字节 SHA256=$srcHash")

    # ===== 1. 清空并初始化为 GPT（diskpart clean 更彻底） =====
    Log('清空磁盘2 (Clear-Disk)...')
    try { Clear-Disk -Number 2 -RemoveData -RemoveOEM -Confirm:$false -ErrorAction Stop }
    catch { Log("Clear-Disk提示(可忽略): $($_.Exception.Message)") }
    Log('diskpart clean + convert gpt ...')
    "select disk 2`r`nclean`r`nconvert gpt`r`nexit" | diskpart | ForEach-Object { if($_ -match 'DiskPart successfully|成功'){ Log("dp: $_") } }
    Start-Sleep -Seconds 2
    Update-HostStorageCache
    $d1 = Get-Disk -Number 2
    Log("clean后分区样式: $($d1.PartitionStyle)")
    if ($d1.PartitionStyle -eq 'RAW') {
        Initialize-Disk -Number 2 -PartitionStyle GPT -Confirm:$false
        Log('Initialize-Disk GPT 完成')
    }

    # ===== 2. 分区1: 200MB FAT32 EFI =====
    Log('创建EFI分区 200MB FAT32...')
    $p1 = New-Partition -DiskNumber 2 -Size 200MB -GptType '{EBD0A0A2-B9E5-4433-87C0-68B6B72699C7}' -AssignDriveLetter
    Start-Sleep -Seconds 2
    Format-Volume -Partition $p1 -FileSystem FAT32 -NewFileSystemLabel 'EFI' -Confirm:$false -Force | Out-Null
    $efiLetter = $p1.DriveLetter
    Log("EFI分区盘符: $efiLetter : 偏移=$($p1.Offset)")

    # ===== 3. 分区2: 剩余空间设为 HFS+ GPT类型（不格式化） =====
    Log('创建HFS数据分区...')
    $p2 = New-Partition -DiskNumber 2 -UseMaximumSize -GptType '{48465300-0000-11AA-AA11-00306543ECAC}'
    Start-Sleep -Seconds 2
    $off = $p2.Offset
    Log("HFS分区偏移: $off  大小: $($p2.Size)")

    # ===== 4. 原始写入 4.hfs =====
    Log('开始写入HFS镜像（约2GB，数分钟）...')
    $infs = [System.IO.File]::OpenRead($srcHfs)
    $dsk  = [System.IO.File]::Open('\\.\PhysicalDrive2',[System.IO.FileMode]::Open,[System.IO.FileAccess]::Write,[System.IO.FileShare]::None)
    $dsk.Seek($off,[System.IO.SeekOrigin]::Begin) | Out-Null
    $buf = New-Object byte[] (4MB); $done=0; $lastp=-1
    while($done -lt $hfsLen){
        $want=[Math]::Min($buf.Length,$hfsLen-$done)
        $n=$infs.Read($buf,0,$want); if($n -le 0){break}
        $dsk.Write($buf,0,$n); $done+=$n
        $p=[int]($done*100/$hfsLen)
        if($p -ne $lastp -and $p % 10 -eq 0){ $lastp=$p; Log("写入 $p%") }
    }
    $dsk.Flush(); $dsk.Close(); $infs.Close()
    Log("写入完成 $done 字节")

    # ===== 5. 读回 SHA256 校验 =====
    Log('读回校验...')
    $id=[System.Security.Cryptography.SHA256]::Create()
    $fs=[System.IO.File]::Open('\\.\PhysicalDrive2',[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
    $fs.Seek($off,[System.IO.SeekOrigin]::Begin)|Out-Null
    $rb=New-Object byte[] (4MB); $rd=0
    while($rd -lt $hfsLen){
        $want=[Math]::Min($rb.Length,$hfsLen-$rd)
        $n=$fs.Read($rb,0,$want); if($n -le 0){break}
        $id.TransformBlock($rb,0,$n,$null,0)|Out-Null; $rd+=$n
    }
    $id.TransformFinalBlock([byte[]]@(),0,0)|Out-Null; $fs.Close()
    $diskHash=[BitConverter]::ToString($id.Hash).Replace('-','')
    if($diskHash -ne $srcHash){ Log("FATAL: 读回校验失败 $diskHash"); exit 2 }
    Log('HFS读回校验 PASS (SHA256一致)')

    # ===== 6. 部署 EFI =====
    Log("复制EFI到 ${efiLetter}:\\EFI ...")
    $dst = "${efiLetter}:\"
    robocopy $srcEfi ($dst + 'EFI') /E /R:2 /W:2 /NFL /NDL /NJH /NJS | Out-Null
    Log("robocopy退出码 $LASTEXITCODE (0-7为成功)")

    # ===== 7. 最终核对 =====
    $okBoot = Test-Path ($dst+'EFI\BOOT\BOOTx64.efi')
    $okOC   = Test-Path ($dst+'EFI\OC\OpenCore.efi')
    $okCfg  = Test-Path ($dst+'EFI\OC\config.plist')
    $okHfs  = Test-Path ($dst+'EFI\OC\Drivers\HfsPlus.efi')
    Log("关键文件: BOOTx64=$okBoot OpenCore=$okOC config=$okCfg HfsPlus=$okHfs 盘符=$efiLetter")
    Log('=== 重建完成 ===')
}
catch {
    Log("ERROR: $($_.Exception.Message)")
    Log($_.ScriptStackTrace)
    exit 9
}
