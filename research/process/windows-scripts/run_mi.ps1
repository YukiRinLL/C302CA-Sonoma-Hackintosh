Add-Content -Path 'E:\hackintosh\runner-stage.txt' -Value ("STARTED " + (Get-Date))
$log = 'E:\hackintosh\makeinstall.log'
$errlog = 'E:\hackintosh\makeinstall.err.log'
Remove-Item $log,$errlog -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = 'C:\Python313\python.exe'
$psi.Arguments = '-u MakeInstall.py'
$psi.WorkingDirectory = 'E:\hackintosh\gibMacOS'
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $psi
Register-ObjectEvent -InputObject $p -EventName OutputDataReceived -Action { if($EventArgs.Data){ Add-Content -Path 'E:\hackintosh\makeinstall.log' -Value $EventArgs.Data } } | Out-Null
Register-ObjectEvent -InputObject $p -EventName ErrorDataReceived -Action { if($EventArgs.Data){ Add-Content -Path 'E:\hackintosh\makeinstall.err.log' -Value $EventArgs.Data } } | Out-Null
[void]$p.Start()
$p.BeginOutputReadLine()
$p.BeginErrorReadLine()
foreach($line in (Get-Content 'E:\hackintosh\mi_input.txt')){ $p.StandardInput.WriteLine($line) }
$p.WaitForExit()
Add-Content -Path $log -Value ("EXIT CODE: " + $p.ExitCode)
Add-Content -Path 'E:\hackintosh\runner-stage.txt' -Value ("FINISHED exit=" + $p.ExitCode + " " + (Get-Date))
