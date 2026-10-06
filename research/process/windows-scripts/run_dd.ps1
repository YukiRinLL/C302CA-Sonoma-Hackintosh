Add-Content -Path 'E:\hackintosh\dd-stage.txt' -Value ("DD START " + (Get-Date))
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = 'E:\hackintosh\gibMacOS\Scripts\ddrelease64.exe'
$psi.Arguments = 'if=E:\hackintosh\hfsimg\4.hfs of=\\?\Device\Harddisk2\Partition2 bs=8M --progress'
$psi.WorkingDirectory = 'E:\hackintosh\gibMacOS\Scripts'
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $psi
Register-ObjectEvent -InputObject $p -EventName OutputDataReceived -Action { if($EventArgs.Data){ Add-Content -Path 'E:\hackintosh\dd.log' -Value $EventArgs.Data } } | Out-Null
Register-ObjectEvent -InputObject $p -EventName ErrorDataReceived -Action { if($EventArgs.Data){ Add-Content -Path 'E:\hackintosh\dd.log' -Value $EventArgs.Data } } | Out-Null
[void]$p.Start()
$p.BeginOutputReadLine()
$p.BeginErrorReadLine()
$p.WaitForExit()
Add-Content -Path 'E:\hackintosh\dd-stage.txt' -Value ("DD FINISHED exit=" + $p.ExitCode + " " + (Get-Date))
