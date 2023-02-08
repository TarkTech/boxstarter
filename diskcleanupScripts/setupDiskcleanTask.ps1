function RemoveDirectoryFiles {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# installation of chocolaty
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "`nInstalling Git"

choco install git.install -y

$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

refreshenv

Write-Host "`nGit Installed"

cd C:/

# Check if the folder exists
if (Test-Path -Path "C:/boxstarter") {
    Write-Host "`nBoxstarter Repo Already Cloned"
} else {
    Write-Host "`nFolder does not exist"

    Write-Host "`nCloning Boxstarter"

    # Clone the repository
    git clone https://git.tarktech.com/pub/boxstarter.git

    Write-Host "`nCloning Complete"
}

cd boxstarter

Write-Host "`nPulling latest changes"

# Pull the latest changes
git pull

Write-Host "`nPulling Complete"

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

$taskAction = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "Start-Process powershell -ArgumentList 'Set-ExecutionPolicy Bypass -Scope Process -Force;cd C:\boxstarter; git pull;cd diskcleanupScripts; .\setupDiskcleanTask.ps1' -Verb RunAs -WindowStyle Hidden"
$taskTrigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Wednesday -At 12pm
# If the task does not exist, create it
if (!$info) {
    Write-Host "Task does not exist"
    Register-ScheduledTask -TaskName $taskName -Description $taskName -Action $taskAction -Trigger $taskTrigger -RunLevel Highest
    Write-Host "$taskName Task created successfully"
} else {
    Write-Host "$taskName Task already exists"
    Set-ScheduledTask -TaskName $taskName -Trigger $taskTrigger
}