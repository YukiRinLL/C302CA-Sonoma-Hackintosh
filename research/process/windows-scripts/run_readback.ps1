Remove-Item 'E:\hackintosh\readback.bin','E:\hackintosh\readback-stage.txt' -ErrorAction SilentlyContinue
Add-Content -Path 'E:\hackintosh\readback-stage.txt' -Value ('RB START ' + (Get-Date))
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = 'E:\hackintosh\gibMacOS\Scripts\ddrelease64.exe'
$psi.Arguments = 'if=\\?\Device\Harddisk2\Partition2 of=E:\hackintosh\readback.bin bs=1M count=1909'
$psi.WorkingDirectory = 'E:\hackintosh\gibMacOS\Scripts'
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $psi
[void]$p.Start()
$out = $p.StandardOutput.ReadToEnd()
$err = $p.StandardError.ReadToEnd()
$p.WaitForExit()
Add-Content -Path 'E:\hackintosh\readback.log' -Value $out
Add-Content -Path 'E:\hackintosh\readback.log' -Value $err
Add-Content -Path 'E:\hackintosh\readback-stage.txt' -Value ('RB FINISHED exit=' + $p.ExitCode + ' ' + (Get-Date))
