# openclaw-uninstall

Cross-platform AI Agent tool uninstaller. Supports OpenClaw, MoltBot, ClawDBot, ClawDBot-CN.

## Features

- ✅ **Multi-tool support**: OpenClaw, MoltBot, ClawDBot, ClawDBot-CN
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

### Windows (CMD)

```cmd
# Download and run
curl -fsSL https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.bat -o uninstall.bat
uninstall.bat
```

### Windows (PowerShell)

```powershell
# Download and run (PowerShell 5.1+)
irm https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.ps1 | iex
```

## What Gets Removed

### CLI
- npm: `npm uninstall -g <tool>`
- pnpm: `pnpm remove -g <tool>`
- bun: `bun pm rm -g <tool>`

### Data Directories
- `~/.openclaw`, `~/.moltbot`, `~/.clawdbot`, `~/.clawdbot-cn`
- `~/.config/openclaw`, etc.
- `~/.local/share/openclaw`, etc.
- `~/openclaw-workspace`, etc.

### Config Files
- `~/.openclawrc`, `~/.moltbotrc`, etc.
- `~/.openclaw-config`, etc.
- `~/.openclaw.json`, etc.

### macOS Specific
- `/Applications/OpenClaw.app`, etc.
- `~/Library/LaunchAgents/com.openclaw.daemon.plist`, etc.

## As OpenClaw Skill

```bash
# Download the script to your workspace
curl -fsSL https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.sh -o ~/.openclaw/uninstall.sh
chmod +x ~/.openclaw/uninstall.sh

# Run it
~/.openclaw/uninstall.sh
```

## License

MIT