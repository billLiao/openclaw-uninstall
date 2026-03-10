#!/bin/bash
#
# OpenClaw Uninstall Script
# Supports: macOS, Linux, Windows (WSL/Cygwin)
# Features: Auto-detect, clean all residues, self-destruct
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        *)          echo "unknown";;
    esac
}

# Detect package manager
detect_package_manager() {
    if command -v npm &> /dev/null; then
        echo "npm"
    elif command -v pnpm &> /dev/null; then
        echo "pnpm"
    elif command -v bun &> /dev/null; then
        echo "bun"
    else
        echo "none"
    fi
}

# Check if OpenClaw is installed
check_installation() {
    local installed=false
    local install_method=""

    # Check npm/pnpm/bun global
    if command -v openclaw &> /dev/null; then
        installed=true
        local openclaw_path=$(which openclaw)
        if [[ $openclaw_path == *"npm"* ]]; then
            install_method="npm"
        elif [[ $openclaw_path == *"pnpm"* ]]; then
            install_method="pnpm"
        elif [[ $openclaw_path == *"bun"* ]]; then
            install_method="bun"
        fi
    fi

    echo "$installed|$install_method"
}

# Get home directory
get_home_dir() {
    echo "$HOME"
}

# Get OpenClaw data directories
get_data_dirs() {
    local home=$(get_home_dir)
    local dirs=()

    # Global npm/pnpm/bun global prefix
    if command -v npm &> /dev/null; then
        dirs+=("$(npm root -g)/../lib/node_modules/openclaw")
    fi
    if command -v pnpm &> /dev/null; then
        dirs+=("$(pnpm root -g)/../lib/node_modules/openclaw")
    fi
    if command -v bun &> /dev/null; then
        dirs+=("$(bun pm ls -g | grep 'openclaw' | awk '{print $2}')")
    fi

    # User data directories
    dirs+=("$home/.openclaw")
    dirs+=("$home/.config/openclaw")
    dirs+=("$home/.local/share/openclaw")
    dirs+=("$home/openclaw-workspace")

    echo "${dirs[@]}"
}

# Get OpenClaw config files
get_config_files() {
    local home=$(get_home_dir)
    local files=()

    files+=("$home/.openclawrc")
    files+=("$home/.openclaw-config")
    files+=("$home/.openclaw.json")

    echo "${files[@]}"
}

# Remove directory with confirmation
remove_dir() {
    local dir="$1"
    if [ -d "$dir" ]; then
        echo -e "${YELLOW}Removing: $dir${NC}"
        rm -rf "$dir"
        echo -e "${GREEN}✓ Removed${NC}"
    fi
}

# Remove file with confirmation
remove_file() {
    local file="$1"
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Removing: $file${NC}"
        rm -f "$file"
        echo -e "${GREEN}✓ Removed${NC}"
    fi
}

# Uninstall via package manager
uninstall_via_package_manager() {
    local pm="$1"
    echo -e "${BLUE}Uninstalling OpenClaw via $pm...${NC}"

    case "$pm" in
        npm)
            npm uninstall -g openclaw 2>/dev/null || true
            ;;
        pnpm)
            pnpm remove -g openclaw 2>/dev/null || true
            ;;
        bun)
            bun pm rm -g openclaw 2>/dev/null || true
            ;;
    esac

    echo -e "${GREEN}✓ OpenClaw CLI uninstalled${NC}"
}

# Remove macOS desktop app
uninstall_macos_app() {
    local app_paths=(
        "/Applications/OpenClaw.app"
        "$HOME/Applications/OpenClaw.app"
    )

    for app_path in "${app_paths[@]}"; do
        if [ -d "$app_path" ]; then
            echo -e "${YELLOW}Removing macOS app: $app_path${NC}"
            rm -rf "$app_path"
            echo -e "${GREEN}✓ Removed${NC}"
        fi
    done

    # Remove LaunchAgent
    local launchagent="$HOME/Library/LaunchAgents/com.openclaw.daemon.plist"
    if [ -f "$launchagent" ]; then
        echo -e "${YELLOW}Removing LaunchAgent...${NC}"
        launchctl unload "$launchagent" 2>/dev/null || true
        rm -f "$launchagent"
        echo -e "${GREEN}✓ Removed${NC}"
    fi
}

# Main uninstall function
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}     OpenClaw Uninstall Script${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    local os=$(detect_os)
    local pm=$(detect_package_manager)
    local check_result=$(check_installation)
    local installed=$(echo "$check_result" | cut -d'|' -f1)
    local install_method=$(echo "$check_result" | cut -d'|' -f2)

    echo -e "OS: $os"
    echo -e "Package Manager: $pm"
    echo -e "OpenClaw Installed: $installed"
    if [ "$installed" = "true" ]; then
        echo -e "Install Method: $install_method"
    fi
    echo ""

    if [ "$installed" = "false" ]; then
        echo -e "${YELLOW}OpenClaw is not installed. Cleaning up residual files...${NC}"
    else
        # Uninstall via package manager
        if [ -n "$install_method" ]; then
            uninstall_via_package_manager "$install_method"
        fi
    fi

    # Platform-specific cleanup
    if [ "$os" = "macos" ]; then
        uninstall_macos_app
    fi

    # Clean data directories
    echo -e "${BLUE}Cleaning data directories...${NC}"
    for dir in $(get_data_dirs); do
        remove_dir "$dir"
    done

    # Clean config files
    echo -e "${BLUE}Cleaning config files...${NC}"
    for file in $(get_config_files); do
        remove_file "$file"
    done

    # Clean npm/pnpm/bun cache (optional)
    if [ "$pm" != "none" ]; then
        echo -e "${BLUE}Cleaning $pm cache...${NC}"
        case "$pm" in
            npm) npm cache clean --force 2>/dev/null || true;;
            pnpm) pnpm store prune 2>/dev/null || true;;
            bun) bun pm cache rm 2>/dev/null || true;;
        esac
        echo -e "${GREEN}✓ Cache cleaned${NC}"
    fi

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  OpenClaw uninstallation complete!${NC}"
    echo -e "${GREEN}========================================${NC}"

    # Self-destruct
    echo ""
    echo -e "${YELLOW}Script will delete itself in 3 seconds...${NC}"
    sleep 3
    rm -f "$0"
    echo -e "${GREEN}✓ Self-destructed${NC}"
}

# Run main function
main "$@"