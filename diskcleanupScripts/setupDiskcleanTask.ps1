function RemoveDirectoryFiles {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Remove all files in the TEMP directory
$tempFilePath = [System.IO.Path]::GetTempPath()

RemoveDirectoryFiles -Path $tempFilePath
RemoveDirectoryFiles -Path "C:\Windows\Temp"

# Cleanup C: drive using Disk Cleanup
cleanmgr.exe /sagerun:66 /VeryLowDisk /AUTOCLEAN | Out-Null

# Add this script to the Task Scheduler to run at startup

$taskName = "RemoveTempFiles"

# Check if the task already exists
$info = Get-ScheduledTask $taskName -ErrorAction SilentlyContinue

# If the task does not exist, create it
if (!$info) {
    Write-Host "Task does not exist"
    $taskAction = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-File C:\StartupScripts\RemoveTempFiles.ps1"
    $taskTrigger = New-ScheduledTaskTrigger -AtLogon
    Register-ScheduledTask -TaskName $taskName -Description $taskName -Action $taskAction -Trigger $taskTrigger -RunLevel Highest -User SYSTEM
    Write-Host "$taskName Task created successfully"
}

Read-Host "Press any key to continue..."