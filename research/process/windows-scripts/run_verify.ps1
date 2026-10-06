$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = 'E:\hackintosh\gibMacOS\Scripts\ddrelease64.exe'
$psi.Arguments = 'if=\\?\Device\Harddisk2\Partition2 of=E:\hackintosh\hdr.bin bs=1024 count=3 --progress'
$psi.WorkingDirectory = 'E:\hackintosh\gibMacOS\Scripts'
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $psi
[void]$p.Start()
$p.WaitForExit()
Add-Content -Path 'E:\hackintosh\verify-stage.txt' -Value ("exit=" + $p.ExitCode)
