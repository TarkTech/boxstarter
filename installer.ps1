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
    $profiles = Get-ChildItem -Path ".\Profiles" -Filter "*.ps1" | Select-Object -ExpandProperty Name | ForEach-Object { $_.Replace(".ps1", "") }

    return $profiles
}

Write-Host "`nInstalling Git"

winget install git.git -h --accept-package-agreements --accept-source-agreements

Write-Host "`nGit Installed"

cd C:/

# Check if the folder exists
if (Test-Path -Path "C:/boxstarter") {
    Write-Host "`nBoxstarter Repo Already Cloned"
} else {
    Write-Host "`nFolder does not exist"

    Write-Host "`nCloning Boxstarter"

    # Clone the repository
    git clone https://git.tarktech.com/utsav.songara/boxstarter.git

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