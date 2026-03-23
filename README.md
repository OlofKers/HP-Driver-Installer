# HP-Driver-Installer

A PowerShell script that automatically detects HP machines and installs the appropriate drivers using **HP Image Assistant**.

## Features

* Automatically detects HP devices.
* Installs drivers silently and efficiently.
* Requires **HPImageAssistant.exe** in the same folder.
* Simple to launch via a batch file with administrative privileges.

## Requirements

* Windows PC manufactured by **HP**.
* **HP Image Assistant (HPImageAssistant.exe)** placed in the same folder as the script.
* Administrative privileges to run the script.
* PowerShell execution policy allowing script execution (the provided batch file handles this automatically).

## Usage

1. Place `HPImageAssistant.exe` in a folder along with `HP-Driver-Installer.ps1`.
2. Run the provided batch file (`RunInstaller.bat`) which will:

   * Check for administrative privileges.
   * Enable one-time script execution.
   * Launch the PowerShell script.
3. The script will detect if the device is an HP machine and begin installing drivers.

> ⚠️ **Note:** This script only works on HP devices. Running it on non-HP hardware will exit the script safely.

## Batch File Example

```batch
@echo off
:: Check for admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run as Administrator.
    pause
    exit /b
)

:: Enable one-time script execution
powershell -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass"

:: Run the installer
powershell -File "HP-Driver-Installer.ps1"
pause
```

## How It Works

1. Detects whether the current device is an HP machine.
2. Calls `HPImageAssistant.exe` to scan and install all necessary drivers.
3. Provides automated driver installation without manual intervention.
