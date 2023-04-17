function GetProfileNameFromUserSelection{ 
    
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

# installation of boxstarter

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force

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

$selectedProfileName = GetProfileNameFromUserSelection

Write-Host "`nSelected profile name: $selectedProfileName`n"

.\supportingFile.ps1 -profile $selectedProfileName

# Set wallpaper
.\setupWallpaper\setWallpaper.ps1

# Run disk cleanup task
.\diskcleanupScripts\setupRegistry.bat
.\diskcleanupScripts\setupDiskcleanTask.ps1

# Uninstall Boxstarter
.\uninstall.ps1

# Reboot the machine
shutdown /r /t 30