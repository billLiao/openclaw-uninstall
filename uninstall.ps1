# OpenClaw/MoltBot/ClawDBot Uninstall Script for Windows PowerShell
# Supports: Windows 10/11 (PowerShell 5.1+)

$ErrorActionPreference = "SilentlyContinue"

# Supported tool names
$ToolNames = @("openclaw", "moltbot", "clawdbot", "clawdbot-cn")

# Colors
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    $colors = @{
        "Red" = "`e[91m"
        "Green" = "`e[92m"
        "Yellow" = "`e[93m"
        "Blue" = "`e[94m"
        "Reset" = "`e[0m"
    }
    Write-Host "$($colors[$Color])$Message$($colors['Reset'])"
}

Write-ColorOutput "========================================" "Blue"
Write-ColorOutput " OpenClaw/MoltBot/ClawDBot Uninstall" "Blue"
Write-ColorOutput "========================================" "Blue"
Write-Host ""

# Detect package manager
$PM = "none"
if (Get-Command npm -ErrorAction SilentlyContinue) { $PM = "npm" }
elseif (Get-Command pnpm -ErrorAction SilentlyContinue) { $PM = "pnpm" }
elseif (Get-Command bun -ErrorAction SilentlyContinue) { $PM = "bun" }

# Check if any supported tool is installed
$INSTALLED = $false
$INSTALLED_TOOL = ""
foreach ($tool in $ToolNames) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        $INSTALLED = $true
        $INSTALLED_TOOL = $tool
        break
    }
}

Write-Host "OS: Windows (PowerShell)"
Write-Host "Package Manager: $PM"
Write-Host "Tool Installed: $INSTALLED"
if ($INSTALLED) {
    Write-Host "Installed Tool: $INSTALLED_TOOL"
}
Write-Host ""

if (-not $INSTALLED) {
    Write-ColorOutput "No supported tool is installed. Cleaning up residual files..." "Yellow"
} else {
    Write-ColorOutput "Uninstalling $INSTALLED_TOOL via $PM..." "Blue"

    switch ($PM) {
        "npm" { 
            foreach ($tool in $ToolNames) { npm uninstall -g $tool }
        }
        "pnpm" { 
            foreach ($tool in $ToolNames) { pnpm remove -g $tool }
        }
        "bun" { 
            foreach ($tool in $ToolNames) { bun pm rm -g $tool }
        }
    }

    Write-ColorOutput "CLI uninstalled." "Green"
}

# Clean data directories
Write-ColorOutput "Cleaning data directories..." "Blue"

$userProfile = $env:USERPROFILE
$appData = $env:APPDATA
$localAppData = $env:LOCALAPPDATA

$dirsToRemove = @()
foreach ($tool in $ToolNames) {
    $dirsToRemove += "$userProfile\.$tool"
    $dirsToRemove += "$appData\$tool"
    $dirsToRemove += "$localAppData\$tool"
    $dirsToRemove += "$userProfile\${tool}-workspace"
}

foreach ($dir in $dirsToRemove) {
    if (Test-Path $dir) {
        Write-ColorOutput "Removing: $dir" "Yellow"
        Remove-Item -Path $dir -Recurse -Force
        Write-ColorOutput "✓ Removed" "Green"
    }
}

# Clean config files
Write-ColorOutput "Cleaning config files..." "Blue"

$filesToRemove = @()
foreach ($tool in $ToolNames) {
    $toolConfig = $tool -replace '-', '_'
    $filesToRemove += "$userProfile\.${tool}rc"
    $filesToRemove += "$userProfile\.${tool}-config"
    $filesToRemove += "$userProfile\.${tool}.json"
}

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
        "npm" { npm cache clean --force }
        "pnpm" { pnpm store prune }
        "bun" { bun pm cache rm }
    }
    Write-ColorOutput "✓ Cache cleaned" "Green"
}

Write-Host ""
Write-ColorOutput "========================================" "Green"
Write-ColorOutput " Uninstallation complete!" "Green"
Write-ColorOutput "========================================" "Green"
Write-Host ""

Write-ColorOutput "Script will delete itself in 3 seconds..." "Yellow"
Start-Sleep -Seconds 3
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
Write-ColorOutput "✓ Self-destructed" "Green"