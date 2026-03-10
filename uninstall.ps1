# OpenClaw Uninstall Script for Windows PowerShell
# Supports: Windows 10/11 (PowerShell 5.1+)

$ErrorActionPreference = "SilentlyContinue"

# Colors
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    $colors = @{
        "Red"     = "`e[91m"
        "Green"   = "`e[92m"
        "Yellow"  = "`e[93m"
        "Blue"    = "`e[94m"
        "Reset"   = "`e[0m"
    }
    Write-Host "$($colors[$Color])$Message$($colors['Reset'])"
}

Write-ColorOutput "========================================" "Blue"
Write-ColorOutput " OpenClaw Uninstall Script (PowerShell)" "Blue"
Write-ColorOutput "========================================" "Blue"
Write-Host ""

# Detect package manager
$PM = "none"
if (Get-Command npm -ErrorAction SilentlyContinue) { $PM = "npm" }
elseif (Get-Command pnpm -ErrorAction SilentlyContinue) { $PM = "pnpm" }
elseif (Get-Command bun -ErrorAction SilentlyContinue) { $PM = "bun" }

# Check if OpenClaw is installed
$INSTALLED = $false
if (Get-Command openclaw -ErrorAction SilentlyContinue) { $INSTALLED = $true }

Write-Host "OS: Windows (PowerShell)"
Write-Host "Package Manager: $PM"
Write-Host "OpenClaw Installed: $INSTALLED"
Write-Host ""

if (-not $INSTALLED) {
    Write-ColorOutput "OpenClaw is not installed. Cleaning up residual files..." "Yellow"
} else {
    Write-ColorOutput "Uninstalling OpenClaw via $PM..." "Blue"
    
    switch ($PM) {
        "npm"  { npm uninstall -g openclaw }
        "pnpm" { pnpm remove -g openclaw }
        "bun"  { bun pm rm -g openclaw }
    }
    
    Write-ColorOutput "OpenClaw CLI uninstalled." "Green"
}

# Clean data directories
Write-ColorOutput "Cleaning data directories..." "Blue"

$userProfile = $env:USERPROFILE
$appData = $env:APPDATA
$localAppData = $env:LOCALAPPDATA

$dirsToRemove = @(
    "$userProfile\.openclaw",
    "$appData\openclaw",
    "$localAppData\openclaw",
    "$userProfile\openclaw-workspace"
)

foreach ($dir in $dirsToRemove) {
    if (Test-Path $dir) {
        Write-ColorOutput "Removing: $dir" "Yellow"
        Remove-Item -Path $dir -Recurse -Force
        Write-ColorOutput "✓ Removed" "Green"
    }
}

# Clean config files
Write-ColorOutput "Cleaning config files..." "Blue"

$filesToRemove = @(
    "$userProfile\.openclawrc",
    "$userProfile\.openclaw-config",
    "$userProfile\.openclaw.json"
)

foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        Write-ColorOutput "Removing: $file" "Yellow"
        Remove-Item -Path $file -Force
        Write-ColorOutput "✓ Removed" "Green"
    }
}

# Clean npm/pnpm/bun cache
if ($PM -ne "none") {
    Write-ColorOutput "Cleaning $PM cache..." "Blue"
    switch ($PM) {
        "npm"  { npm cache clean --force }
        "pnpm" { pnpm store prune }
        "bun"  { bun pm cache rm }
    }
    Write-ColorOutput "✓ Cache cleaned" "Green"
}

Write-Host ""
Write-ColorOutput "========================================" "Green"
Write-ColorOutput " OpenClaw uninstallation complete!" "Green"
Write-ColorOutput "========================================" "Green"
Write-Host ""

Write-ColorOutput "Script will delete itself in 3 seconds..." "Yellow"
Start-Sleep -Seconds 3
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
Write-ColorOutput "✓ Self-destructed" "Green"