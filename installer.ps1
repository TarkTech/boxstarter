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

# installation of winget

if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "`nWinget already installed"
} else {
    Write-Host "`nWinget not installed"

    Write-Host "`nInstalling winget"

    # Install winget
    $ProgressPreference='Silent'
    Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    
    # Remove downloaded files
    Remove-Item .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Remove-Item .\Microsoft.VCLibs.x64.14.00.Desktop.appx

    Write-Host "`nWinget installed"
}


Write-Host "`nInstalling Git"

winget install -e --silent --id Git.Git;

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

winget upgrade --all

# Set wallpaper
.\setupWallpaper\setWallpaper.ps1

# Run disk cleanup task
.\diskcleanupScripts\setupRegistry.bat
.\diskcleanupScripts\setupDiskcleanTask.ps1

# Uninstall Boxstarter
.\uninstall.ps1

# Reboot the machine
shutdown /r /t 30