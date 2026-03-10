# OpenClaw Uninstall Skill

This skill allows OpenClaw to uninstall itself completely.

## Description

Completely removes OpenClaw CLI and all residual files from the system. Supports macOS, Linux, and Windows.

## Tools Used

- `exec`: Download and execute the uninstall script

## How It Works

1. Downloads the uninstall script from GitHub
2. Executes it with appropriate permissions
3. The script handles all cleanup and self-deletion

## Usage

```bash
# Download and run the uninstall script
curl -fsSL https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.sh | bash
```

Or as a skill in OpenClaw:

```
User: Uninstall OpenClaw
Agent: Downloads and runs the uninstall script
```

## What Gets Removed

- OpenClaw CLI (npm/pnpm/bun)
- All configuration files
- All workspace data
- All state files
- macOS desktop app (if installed)
- LaunchAgent (if installed)

## Warning

This action is irreversible. Make sure to backup any important data before running.