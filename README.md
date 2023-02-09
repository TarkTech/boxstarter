## Summary

- Easy to setup new windows machine softwares using powershell script.
- User don't worried about how to download software and installing software on your systems.
- User need to run software installation script on powershell that ask only your profile name on that based your required software auto install on your system.
- Script auto set wallpaper on your system.
- We provide auto cleanup temp files on system at every week wednesday that script cleanup temp file & other unnessesary files on your system.
- For start intallation only run single command and your software installation will start.

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

- **If you choice backend profile that installing backend profile & also installing dev profile & base profile softwares.**

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

## Start Software Installation

> Open PowerShell terminal as administrator and run below command

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://git.tarktech.com/api/v4/projects/254/repository/files/installer.ps1/raw/?ref=main'));
```

## Setup autocleanup junk files on every wednesday

> Open PowerShell terminal as administrator and run below command

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; ((New-Object System.Net.WebClient).DownloadString('https://git.tarktech.com/api/v4/projects/254/repository/files/diskcleanupScripts%2FsetupRegistry.bat/raw/?ref=main')) | cmd; iex ((New-Object System.Net.WebClient).DownloadString('https://git.tarktech.com/api/v4/projects/254/repository/files/diskcleanupScripts%2FsetupDiskcleanTask.ps1/raw/?ref=main')); C:\boxstarter\setupWallpaper\setWallpaper.ps1;
```