function PrintProfileNames {
    # Get profile names from the Profiles folder
    $profiles = GetProfileNames

    Write-Host "`nProfile Names:`n"

    # Print the profile name
    $count = 1
    foreach ($profile in $profiles) {
        Write-Host $count $profile
        $count++
    }

    Write-Host "`n"
}

function GetProfileNames {
    # Get profile names from the Profiles folder
    $profiles = Get-ChildItem -Path ".\Profiles" -Exclude "_*" | Select-Object -ExpandProperty Name | Where Name -match '' | ForEach-Object { $_.Replace(".ps1", "") }

    return $profiles
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
    git clone https://git.tarktech.com/tark-tech/boxstarter.git

    Write-Host "`nCloning Complete"
}

cd boxstarter

Write-Host "`nPulling latest changes"

# Pull the latest changes
git pull

Write-Host "`nPulling Complete"

PrintProfileNames

# Get profile names from the Profiles folder
$profiles = GetProfileNames

$profile = Read-Host -Prompt "Enter the profile name "

# Until the profile name is not in the list, keep asking the user to enter the profile name
while (-not ($profiles -contains $profile)) {
    Write-Host "`nProfile does not exist"
    PrintProfileNames
    $profile = Read-Host -Prompt "Enter the profile name "
    Write-Host "`nSelected profile name: $profile`n"
}

.\supportingFile.ps1 -profile $profile

.\uninstall.ps1

# Reboot the machine
shutdown /r /t 30