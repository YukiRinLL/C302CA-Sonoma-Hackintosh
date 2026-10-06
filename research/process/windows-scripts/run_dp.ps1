$out = & "$env:SystemRoot\System32\diskpart.exe" /s 'E:\hackintosh\dp.txt' 2>&1
$out | Set-Content 'E:\hackintosh\dp.log'
Add-Content -Path 'E:\hackintosh\dp-stage.txt' -Value ("DONE " + (Get-Date))
