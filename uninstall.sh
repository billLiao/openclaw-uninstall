#!/bin/bash
#
# OpenClaw/MoltBot/ClawDBot Uninstall Script
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

# Supported tool names
TOOL_NAMES=("openclaw" "moltbot" "clawdbot" "clawdbot-cn")

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

# Check if any supported tool is installed
check_installation() {
    local installed=false
    local install_method=""
    local installed_tool=""

    # Check npm/pnpm/bun global for each tool
    for tool in "${TOOL_NAMES[@]}"; do
        if command -v "$tool" &> /dev/null; then
            installed=true
            installed_tool="$tool"
            local tool_path=$(which "$tool")
            if [[ $tool_path == *"npm"* ]]; then
                install_method="npm"
            elif [[ $tool_path == *"pnpm"* ]]; then
                install_method="pnpm"
            elif [[ $tool_path == *"bun"* ]]; then
                install_method="bun"
            fi
            break
        fi
    done

    echo "$installed|$install_method|$installed_tool"
}

# Get home directory
get_home_dir() {
    echo "$HOME"
}

# Get tool data directories
get_data_dirs() {
    local home=$(get_home_dir)
    local dirs=()

    # Global npm/pnpm/bun global prefix for each tool
    for tool in "${TOOL_NAMES[@]}"; do
        if command -v npm &> /dev/null; then
            dirs+=("$(npm root -g)/../lib/node_modules/$tool")
        fi
        if command -v pnpm &> /dev/null; then
            dirs+=("$(pnpm root -g)/../lib/node_modules/$tool")
        fi
        if command -v bun &> /dev/null; then
            dirs+=("$(bun pm ls -g | grep '$tool' | awk '{print $2}')")
        fi
    done

    # User data directories for each tool
    for tool in "${TOOL_NAMES[@]}"; do
        local tool_config=$(echo "$tool" | tr '-' '_')
        dirs+=("$home/.$tool")
        dirs+=("$home/.config/$tool")
        dirs+=("$home/.local/share/$tool")
        dirs+=("$home/${tool}-workspace")
    done

    echo "${dirs[@]}"
}

# Get tool config files
get_config_files() {
    local home=$(get_home_dir)
    local files=()

    for tool in "${TOOL_NAMES[@]}"; do
        local tool_config=$(echo "$tool" | tr '-' '_')
        files+=("$home/.${tool}rc")
        files+=("$home/.${tool}-config")
        files+=("$home/.${tool}.json")
    done

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
    local installed_tool="$2"
    
    echo -e "${BLUE}Uninstalling $installed_tool via $pm...${NC}"

    case "$pm" in
    npm)
        for tool in "${TOOL_NAMES[@]}"; do
            npm uninstall -g "$tool" 2>/dev/null || true
        done
        ;;
    pnpm)
        for tool in "${TOOL_NAMES[@]}"; do
            pnpm remove -g "$tool" 2>/dev/null || true
        done
        ;;
    bun)
        for tool in "${TOOL_NAMES[@]}"; do
            bun pm rm -g "$tool" 2>/dev/null || true
        done
        ;;
    esac

    echo -e "${GREEN}✓ CLI uninstalled${NC}"
}

# Remove macOS desktop app
uninstall_macos_app() {
    for tool in "${TOOL_NAMES[@]}"; do
        local app_name=$(echo "$tool" | tr '[:lower:]' '[:upper:]')
        local app_paths=(
            "/Applications/${app_name}.app"
            "$HOME/Applications/${app_name}.app"
        )

        for app_path in "${app_paths[@]}"; do
            if [ -d "$app_path" ]; then
                echo -e "${YELLOW}Removing macOS app: $app_path${NC}"
                rm -rf "$app_path"
                echo -e "${GREEN}✓ Removed${NC}"
            fi
        done

        # Remove LaunchAgent
        local launchagent="$HOME/Library/LaunchAgents/com.${tool}.daemon.plist"
        if [ -f "$launchagent" ]; then
            echo -e "${YELLOW}Removing LaunchAgent...${NC}"
            launchctl unload "$launchagent" 2>/dev/null || true
            rm -f "$launchagent"
            echo -e "${GREEN}✓ Removed${NC}"
        fi
    done
}

# Main uninstall function
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}     OpenClaw/MoltBot/ClawDBot Uninstall${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    local os=$(detect_os)
    local pm=$(detect_package_manager)
    local check_result=$(check_installation)
    local installed=$(echo "$check_result" | cut -d'|' -f1)
    local install_method=$(echo "$check_result" | cut -d'|' -f2)

    echo -e "OS: $os"
    echo -e "Package Manager: $pm"
    echo -e "Tool Installed: $installed"
    if [ "$installed" = "true" ]; then
        echo -e "Install Method: $install_method"
    fi
    echo ""

    if [ "$installed" = "false" ]; then
        echo -e "${YELLOW}No supported tool is installed. Cleaning up residual files...${NC}"
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
    echo -e "${GREEN}  Uninstallation complete!${NC}"
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