Start-Transcript -Path "E:\hackintosh\sonoma\repart.log" -Force | Out-Null
"=== diskpart begin ==="
diskpart /s "E:\hackintosh\sonoma\repartition.txt"
"=== diskpart exit code: $LASTEXITCODE ==="
Start-Sleep -Seconds 3
"=== disk state ==="
Get-Disk -Number 2 | Format-List Number,FriendlyName,BusType,PartitionStyle,OperationalStatus,Size
"=== partitions ==="
Get-Partition -DiskNumber 2 | Format-Table PartitionNumber,DriveLetter,Size,Type,GptType -AutoSize
"=== volumes ==="
Get-Partition -DiskNumber 2 | Get-Volume | Format-Table DriveLetter,FileSystemLabel,FileSystem,Size,HealthStatus -AutoSize
Stop-Transcript | Out-Null
