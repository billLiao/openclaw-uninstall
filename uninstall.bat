@echo off
REM OpenClaw Uninstall Script for Windows
REM Supports: Windows 10/11

setlocal enabledelayedexpansion

set "RED=[92;31m"
set "GREEN=[92;32m"
set "YELLOW=[92;33m"
set "BLUE=[92;34m"
set "NC=[0m"

echo ========================================
echo      OpenClaw Uninstall Script (Windows)
echo ========================================
echo.

REM Detect package manager
set "PM=none"
where npm >nul 2>&1 && set "PM=npm"
where pnpm >nul 2>&1 && set "PM=pnpm"
where bun >nul 2>&1 && set "PM=bun"

REM Check if OpenClaw is installed
set "INSTALLED=false"
where openclaw >nul 2>&1 && set "INSTALLED=true"

echo OS: Windows
echo Package Manager: %PM%
echo OpenClaw Installed: %INSTALLED%
echo.

if "%INSTALLED%"=="false" (
    echo OpenClaw is not installed. Cleaning up residual files...
) else (
    echo Uninstalling OpenClaw via %PM%...
    if "%PM%"=="npm" (
        npm uninstall -g openclaw 2>nul
    ) else if "%PM%"=="pnpm" (
        pnpm remove -g openclaw 2>nul
    ) else if "%PM%"=="bun" (
        bun pm rm -g openclaw 2>nul
    )
    echo OpenClaw CLI uninstalled.
)

REM Clean data directories
echo.
echo Cleaning data directories...
set "USERPROFILE=%USERPROFILE%"

if exist "%USERPROFILE%\.openclaw" (
    echo Removing: %USERPROFILE%\.openclaw
    rmdir /s /q "%USERPROFILE%\.openclaw"
)

if exist "%APPDATA%\openclaw" (
    echo Removing: %APPDATA%\openclaw
    rmdir /s /q "%APPDATA%\openclaw"
)

if exist "%LOCALAPPDATA%\openclaw" (
    echo Removing: %LOCALAPPDATA%\openclaw
    rmdir /s /q "%LOCALAPPDATA%\openclaw"
)

REM Clean config files
echo.
echo Cleaning config files...
if exist "%USERPROFILE%\.openclawrc" (
    del /f /q "%USERPROFILE%\.openclawrc"
)
if exist "%USERPROFILE%\.openclaw-config" (
    del /f /q "%USERPROFILE%\.openclaw-config"
)
if exist "%USERPROFILE%\.openclaw.json" (
    del /f /q "%USERPROFILE%\.openclaw.json"
)

REM Clean npm cache
if "%PM%"=="npm" (
    echo.
    echo Cleaning npm cache...
    npm cache clean --force 2>nul
)

echo.
echo ========================================
echo   OpenClaw uninstallation complete!
echo ========================================
echo.
echo Script will delete itself in 3 seconds...
timeout /t 3 /nobreak >nul
del "%~f0"
echo Self-destructed.

endlocal