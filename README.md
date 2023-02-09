## Summary

- One click setup.
- Prompts to configure softwares while setup
- Script auto set wallpaper on your system.
- Personalize desktop
- Performs auto cleanup regularly

---

## Profiles Level

```
Profiles

    base
    |── dev
    |  ├── frontend
    |  |── backend
    |  └── mobile
    └── qa
```

- **Qa profile will setup only based profile while developers will have dev as well as base profile to configure and personalize softwares**

---

## Software installation list

> **base profile**
- googlechrome
- firefox
- sharex
- microsoft-teams
- remove unnessasary software from system

> **dev profile**
- git
- nodejs
- vscode

> **backend profile**
- visualstudio2022 ( community addition )
- dotnet-sdk-6.0

> **mobile profile**
- android-studio 
- xamarin-studio

> **qa profile**
- notepad++


---

## Start software installation

> Open PowerShell terminal as administrator and run below command

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://git.tarktech.com/api/v4/projects/254/repository/files/installer.ps1/raw/?ref=main'));
```

## Setup auto cleanup junk files on every wednesday

> Open PowerShell terminal as administrator and run below command

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; ((New-Object System.Net.WebClient).DownloadString('https://git.tarktech.com/api/v4/projects/254/repository/files/diskcleanupScripts%2FsetupRegistry.bat/raw/?ref=main')) | cmd; iex ((New-Object System.Net.WebClient).DownloadString('https://git.tarktech.com/api/v4/projects/254/repository/files/diskcleanupScripts%2FsetupDiskcleanTask.ps1/raw/?ref=main')); C:\boxstarter\setupWallpaper\setWallpaper.ps1;
```