## Installation

1) Open powershell terminal and run below command

```powershell
Start-Process powershell -ArgumentList "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://git.tarktech.com/api/v4/projects/254/repository/files/installer.ps1/raw/?ref=main'));" -Verb RunAs
```