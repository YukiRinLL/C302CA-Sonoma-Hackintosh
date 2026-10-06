$ErrorActionPreference = 'Stop'
$out = 'E:\hackintosh\hfsimg\verify_result.txt'
try {
    $id = [System.Security.Cryptography.SHA256]::Create()
    $fs = [System.IO.File]::Open('\\.\PhysicalDrive2',[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
    $fs.Seek(210763776,[System.IO.SeekOrigin]::Begin) | Out-Null
    $buf = New-Object byte[] (4*1024*1024)
    $total = 2001362944
    $done = 0
    while ($done -lt $total) {
        $want = [Math]::Min($buf.Length,$total-$done)
        $n = $fs.Read($buf,0,$want)
        if ($n -le 0) { break }
        $id.TransformBlock($buf,0,$n,$null,0) | Out-Null
        $done += $n
    }
    $id.TransformFinalBlock([byte[]]@(),0,0) | Out-Null
    $fs.Close()
    $diskHash = [BitConverter]::ToString($id.Hash).Replace('-','')
    $srcHash  = (Get-FileHash 'E:\hackintosh\hfsimg\4.hfs' -Algorithm SHA256).Hash
    "读取字节: $done / $total" | Out-File $out
    "磁盘分区: $diskHash" | Out-File $out -Append
    "源镜像:   $srcHash" | Out-File $out -Append
    if ($diskHash -eq $srcHash) { "结果: PASS 完全一致，镜像未损坏" | Out-File $out -Append }
    else { "结果: FAIL 分区与镜像不一致，HFS数据已被改写/损坏" | Out-File $out -Append }
} catch {
    "ERROR: $($_.Exception.Message)" | Out-File $out
}
