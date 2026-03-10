# openclaw-uninstall

A cross-platform uninstall script for OpenClaw that completely removes OpenClaw CLI and all residual files.

## Features

- ✅ **Cross-platform**: macOS, Linux, Windows (WSL/Cygwin)
- ✅ **Auto-detection**: Automatically detects CLI installation
- ✅ **Smart path selection**: Intelligently finds all installation paths
- ✅ **Clean all residues**: Removes state, config, workspace, multi-profile data
- ✅ **Uninstall CLI**: Supports npm, pnpm, bun
- ✅ **macOS app removal**: Removes desktop app and LaunchAgent
- ✅ **Self-destruct**: Script deletes itself after execution

## Usage

### Unix-like (macOS/Linux)

```bash
# Download and run
curl -fsSL https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.sh | bash

# Or run locally
chmod +x uninstall.sh
./uninstall.sh
```

### Windows

```cmd
# Run as Administrator
uninstall.bat
```

## What Gets Removed

### CLI
- npm global: `npm uninstall -g openclaw`
- pnpm global: `pnpm remove -g openclaw`
- bun global: `bun pm rm -g openclaw`

### Data Directories
- `~/.openclaw`
- `~/.config/openclaw`
- `~/.local/share/openclaw`
- `~/openclaw-workspace`

### Config Files
- `~/.openclawrc`
- `~/.openclaw-config`
- `~/.openclaw.json`

### macOS Specific
- `/Applications/OpenClaw.app`
- `~/Library/LaunchAgents/com.openclaw.daemon.plist`

## As OpenClaw Skill

You can also use this as an OpenClaw skill to uninstall OpenClaw from within itself:

```bash
# Download the script to your workspace
curl -fsSL https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.sh -o ~/.openclaw/uninstall.sh
chmod +x ~/.openclaw/uninstall.sh

# Run it
~/.openclaw/uninstall.sh
```

## License

MIT