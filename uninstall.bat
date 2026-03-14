@echo off
REM OpenClaw/MoltBot/ClawDBot Uninstall Script for Windows
REM Supports: Windows 10/11

setlocal enabledelayedexpansion

set "RED=[92;31m"
set "GREEN=[92;32m"
set "YELLOW=[92;33m"
set "BLUE=[92;34m"
set "NC=[0m"

echo ========================================
echo OpenClaw/MoltBot/ClawDBot Uninstall
echo ========================================
echo.

REM Supported tool names
set "TOOLS=openclaw moltbot clawdbot clawdbot-cn"

REM Detect package manager
set "PM=none"
where npm >nul 2>&1 && set "PM=npm"
where pnpm >nul 2>&1 && set "PM=pnpm"
where bun >nul 2>&1 && set "PM=bun"

REM Check if any supported tool is installed
set "INSTALLED=false"
set "INSTALLED_TOOL="
for %%t in (%TOOLS%) do (
    where %%t >nul 2>&1 (
        set "INSTALLED=true"
        set "INSTALLED_TOOL=%%t"
    )
)

echo OS: Windows
echo Package Manager: %PM%
echo Tool Installed: %INSTALLED%
if "%INSTALLED%"=="true" (
    echo Installed Tool: %INSTALLED_TOOL%
)
echo.

if "%INSTALLED%"=="false" (
    echo No supported tool is installed. Cleaning up residual files...
) else (
    echo Uninstalling %INSTALLED_TOOL% via %PM%...
    if "%PM%"=="npm" (
        for %%t in (%TOOLS%) do npm uninstall -g %%t 2>nul
    ) else if "%PM%"=="pnpm" (
        for %%t in (%TOOLS%) do pnpm remove -g %%t 2>nul
    ) else if "%PM%"=="bun" (
        for %%t in (%TOOLS%) do bun pm rm -g %%t 2>nul
    )
    echo CLI uninstalled.
)

REM Clean data directories
echo.
echo Cleaning data directories...
set "USERPROFILE=%USERPROFILE%"

for %%t in (%TOOLS%) do (
    if exist "%USERPROFILE%\._%%t" (
        echo Removing: %USERPROFILE%\._%%t
        rmdir /s /q "%USERPROFILE%\._%%t"
    )
    if exist "%APPDATA%\%%t" (
        echo Removing: %APPDATA%\%%t
        rmdir /s /q "%APPDATA%\%%t"
    )
    if exist "%LOCALAPPDATA%\%%t" (
        echo Removing: %LOCALAPPDATA%\%%t
        rmdir /s /q "%LOCALAPPDATA%\%%t"
    )
    if exist "%USERPROFILE%\%%t-workspace" (
        echo Removing: %USERPROFILE%\%%t-workspace
        rmdir /s /q "%USERPROFILE%\%%t-workspace"
    )
)

REM Clean config files
echo.
echo Cleaning config files...
for %%t in (%TOOLS%) do (
    set "tool_config=%%t"
    set "tool_config=!tool_config:-=_!"
    if exist "%USERPROFILE%\.%%trc" (
        del /f /q "%USERPROFILE%\.%%trc"
    )
    if exist "%USERPROFILE%\.%%t-config" (
        del /f /q "%USERPROFILE%\.%%t-config"
    )
    if exist "%USERPROFILE%\.%%t.json" (
        del /f /q "%USERPROFILE%\.%%t.json"
    )
)

REM Clean npm/pnpm/bun cache
if "%PM%"=="npm" (
    echo.
    echo Cleaning npm cache...
    npm cache clean --force 2>nul
) else if "%PM%"=="pnpm" (
    echo.
    echo Cleaning pnpm cache...
    pnpm store prune 2>nul
) else if "%PM%"=="bun" (
    echo.
    echo Cleaning bun cache...
    bun pm cache rm 2>nul
)

echo.
echo ========================================
echo Uninstallation complete!
echo ========================================
echo.
echo Script will delete itself in 3 seconds...
timeout /t 3 /nobreak >nul
del "%~f0"
echo Self-destructed.

endlocal