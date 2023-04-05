Function GetProfileNameFromUserSelection (){ 
    
    #This function is used to get the profile name from the user selection
    $profileSelectionTitle = "Choose your installatoin profile?"

    $profileOptions = GetProfileNames

    $maxProfileOptionsCount = $profileOptions.count-1
    $currentSelection = 0
    $enterPressed = $False
    
    While($enterPressed -eq $False){
        Clear-Host
        
        Write-Host "$profileSelectionTitle"

        For ($i=0; $i -lt $profileOptions.count; $i++){

            If(($i) -eq $currentSelection){
                Write-Host -BackgroundColor cyan -ForegroundColor Black "$($profileOptions[$i])"
            } Else {
                Write-Host "$($profileOptions[$i])"
            }

        }

        $keyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

        Switch($keyInput){
            13{
                $enterPressed = $True
                Return $profileOptions[$currentSelection]
                break
            }

            38{ #Up
                If (($currentSelection - 1) -lt 0){
                    $currentSelection = 0
                } Else {
                    $currentSelection -= 1
                }
                break
            }

            40{ #Down
                If ($currentSelection + 1 -gt $maxProfileOptionsCount){
                    $currentSelection = $maxProfileOptionsCount
                } Else {
                    $currentSelection += 1
                }
                break
            }
            Default{
            }
        }
    }
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

$selectedProfileName = GetProfileNameFromUserSelection

Write-Host "`nSelected profile name: $selectedProfileName`n"

.\supportingFile.ps1 -profile $selectedProfileName

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