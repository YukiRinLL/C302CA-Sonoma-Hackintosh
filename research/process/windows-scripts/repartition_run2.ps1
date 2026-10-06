Start-Transcript -Path "E:\hackintosh\sonoma\repart2.log" -Force | Out-Null
"=== format partition1 F: as FAT32 ==="
Format-Volume -DriveLetter F -FileSystem FAT32 -NewFileSystemLabel "EFI" -Confirm:$false -Force | Format-List DriveLetter,FileSystemLabel,FileSystem,Size,HealthStatus
"=== create partition2 with rest of disk ==="
$p2 = New-Partition -DiskNumber 2 -UseMaximumSize -AssignDriveLetter -GptType "{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}"
$p2 | Format-List PartitionNumber,DriveLetter,Size,GptType
"=== format partition2 as exFAT ==="
Format-Volume -DriveLetter $p2.DriveLetter -FileSystem exFAT -NewFileSystemLabel "TARGET" -Confirm:$false -Force | Format-List DriveLetter,FileSystemLabel,FileSystem,Size,HealthStatus
Start-Sleep -Seconds 2
"=== final partitions ==="
Get-Partition -DiskNumber 2 | Format-Table PartitionNumber,DriveLetter,Size,Type,GptType -AutoSize
"=== final volumes ==="
Get-Partition -DiskNumber 2 | Get-Volume | Format-Table DriveLetter,FileSystemLabel,FileSystem,Size,HealthStatus -AutoSize
Stop-Transcript | Out-Null
