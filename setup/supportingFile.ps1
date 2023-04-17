param(
    [Parameter(Mandatory=$true)]
    [string]$profile = "base"
)

Install-BoxstarterPackage -PackageName ".\Profiles\$profile.ps1" -DisableReboots