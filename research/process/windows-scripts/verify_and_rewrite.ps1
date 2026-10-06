$ErrorActionPreference = 'Stop'
$out = 'E:\hackintosh\hfsimg\verify_result.txt'
function Log($m){ $t=Get-Date -Format 'HH:mm:ss'; "$t $m" | Tee-Object -FilePath $out -Append | Out-Host }
Set-Content $out "=== 开始 $(Get-Date) ==="

try {
    # --- 0. 磁盘身份双保险：必须是磁盘2、可移动、容量~64GB ---
    $disk = Get-Disk -Number 2
    Log("磁盘2: Number=$($disk.Number) Friendly='$($disk.FriendlyName)' Size=$($disk.Size) BusType=$($disk.BusType)")
    if ($disk.Size -lt 60000000000 -or $disk.Size -gt 66000000000) {
        Log("ABORT: 磁盘2容量($($disk.Size))不像64GB U盘，拒绝写入")
        exit 1
    }

    $srcPath = 'E:\hackintosh\hfsimg\4.hfs'
    $srcLen  = (Get-Item $srcPath).Length
    $offset  = 210763776   # 分区2起始字节偏移 (LBA 0x64800)
    Log("源镜像长度: $srcLen  写入偏移: $offset")
    $srcHash = (Get-FileHash $srcPath -Algorithm SHA256).Hash
    Log("源镜像SHA256: $srcHash")

    function Read-PartHash {
        $id = [System.Security.Cryptography.SHA256]::Create()
        $fs = [System.IO.File]::Open('\\.\PhysicalDrive2',[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
        $fs.Seek($offset,[System.IO.SeekOrigin]::Begin) | Out-Null
        $buf = New-Object byte[] (4*1024*1024); $done=0
        while($done -lt $srcLen){
            $want=[Math]::Min($buf.Length,$srcLen-$done)
            $n=$fs.Read($buf,0,$want); if($n -le 0){break}
            $id.TransformBlock($buf,0,$n,$null,0)|Out-Null; $done+=$n
        }
        $id.TransformFinalBlock([byte[]]@(),0,0)|Out-Null; $fs.Close()
        return @{ Hash=[BitConverter]::ToString($id.Hash).Replace('-',''); Done=$done }
    }

    # --- 1. 读校验 ---
    Log("第一步：读取数据分区前 $srcLen 字节校验...")
    $r = Read-PartHash
    Log("分区读回: $($r.Done) 字节  SHA256: $($r.Hash)")

    if ($r.Hash -eq $srcHash) {
        Log("PASS: 镜像完好无损，无需重写")
        exit 0
    }
    Log("FAIL: 分区内容与源镜像不一致，判定热拔损坏，开始重写...")

    # --- 2. 写入 ---
    $infs = [System.IO.File]::OpenRead($srcPath)
    $dsk  = [System.IO.File]::Open('\\.\PhysicalDrive2',[System.IO.FileMode]::Open,[System.IO.FileAccess]::Write,[System.IO.FileShare]::None)
    $dsk.Seek($offset,[System.IO.SeekOrigin]::Begin) | Out-Null
    $buf = New-Object byte[] (4*1024*1024); $done=0; $pct=-1
    while($done -lt $srcLen){
        $want=[Math]::Min($buf.Length,$srcLen-$done)
        $n=$infs.Read($buf,0,$want)
        if($n -le 0){break}
        $dsk.Write($buf,0,$n); $done+=$n
        $p=[int]([Math]::Floor($done*100.0/$srcLen))
        if($p -ne $pct -and $p % 10 -eq 0){ $pct=$p; Log("写入进度 $p% ($done / $srcLen)") }
    }
    $dsk.Flush(); $dsk.Close(); $infs.Close()
    Log("写入完成: $done 字节")

    # --- 3. 读回复验 ---
    Log("第二步：读回校验...")
    $r2 = Read-PartHash
    Log("重写后分区SHA256: $($r2.Hash)")
    if ($r2.Hash -eq $srcHash) { Log("REWRITE PASS: 重写并校验一致") }
    else { Log("REWRITE FAIL: 写后仍不一致！") }
}
catch {
    Log("ERROR: $($_.Exception.Message)")
}
