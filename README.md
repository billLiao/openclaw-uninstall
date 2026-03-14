# openclaw-uninstall

跨平台 OpenClaw 完全卸载工具，一键清理 CLI 及所有残留文件。

## 功能特性

- ✅ **跨平台支持**：macOS、Linux、Windows (WSL/Cygwin)
- ✅ **自动检测**：智能识别 CLI 安装方式
- ✅ **智能路径**：自动查找所有安装路径
- ✅ **彻底清理**：移除状态、配置、工作区、多配置文件数据
- ✅ **卸载 CLI**：支持 npm、pnpm、bun
- ✅ **macOS 清理**：移除桌面应用和 LaunchAgent
- ✅ **自毁机制**：执行完毕后自动删除脚本，不留痕迹

## 使用方法

### Unix 系统（macOS/Linux）

```bash
# 下载并执行
curl -fsSL https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.sh | bash

# 或本地执行
chmod +x uninstall.sh
./uninstall.sh
```

### Windows (CMD)

```cmd
# 下载并执行
curl -fsSL https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.bat -o uninstall.bat
uninstall.bat
```

### Windows (PowerShell)

```powershell
# 下载并执行（PowerShell 5.1+）
irm https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.ps1 | iex
```

## 清理内容

### CLI 卸载
- npm 全局：`npm uninstall -g openclaw`
- pnpm 全局：`pnpm remove -g openclaw`
- bun 全局：`bun pm rm -g openclaw`

### 数据目录
- `~/.openclaw`
- `~/.config/openclaw`
- `~/.local/share/openclaw`
- `~/openclaw-workspace`

### 配置文件
- `~/.openclawrc`
- `~/.openclaw-config`
- `~/.openclaw.json`

### macOS 特有
- `/Applications/OpenClaw.app`
- `~/Library/LaunchAgents/com.openclaw.daemon.plist`

## 作为 OpenClaw Skill 使用

你也可以将此脚本作为 OpenClaw Skill 来使用，从内部卸载 OpenClaw：

```bash
# 将脚本下载到工作区
curl -fsSL https://raw.githubusercontent.com/billLiao/openclaw-uninstall/main/uninstall.sh -o ~/.openclaw/uninstall.sh
chmod +x ~/.openclaw/uninstall.sh

# 执行卸载
~/.openclaw/uninstall.sh
```

## 许可证

MIT