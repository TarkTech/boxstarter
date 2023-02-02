param(
    [Parameter(Mandatory=$true)]
    [string]$profile = "base"
)

# installation of chocolaty & boxstarter
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force

Install-BoxstarterPackage -PackageName ".\Profiles\$profile.ps1" -DisableReboots

# Reboot the machine
shutdown /r /t 0