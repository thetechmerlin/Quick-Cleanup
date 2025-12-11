# Merlin's Quick Clean Up

A dual-platform system maintenance tool that keeps your computer running smoothly with an interactive, user-friendly interface.

<p align="center">
<img src="https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue?style=for-the-badge" alt="Platform">
<img src="https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge" alt="Version">
<img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">
</p>

---

## 🧙‍♂️ Overview

Merlin's Quick Clean Up is a powerful yet safe system maintenance tool that automates the process of cleaning temporary files, optimizing performance, and monitoring system health. With its distinctive moss green terminal interface and interactive menu system, it makes system maintenance accessible to users of all skill levels.

### Features

- **Interactive Menu**: Choose individual tasks or run a full tune-up
- **Skip Functionality**: Skip any task during full tune-up with a simple prompt
- **Real-time Logging**: Comprehensive logging of all actions performed
- **Safety First**: Non-destructive operations with user confirmations
- **Visual Feedback**: Color-coded output with step-by-step progress indicators
- **Cross-Platform**: Available for both Ubuntu/Linux and Windows systems

---

## 📋 Tasks Included

| Task | Linux | Windows | Description |
|------|-------|---------|-------------|
| Clean Temporary Files | ✅ | ✅ | Removes temp files, cache, and browser data |
| Clean Package/Update Cache | ✅ | ✅ | Clears system update caches |
| Clean System Logs | ✅ | ✅ | Archives and clears old log files |
| Clean Miscellaneous Files | ✅ | ✅ | Empties trash/recycle bin, old downloads |
| Disk Health Check | ✅ | ✅ | SMART status and disk space analysis |
| Filesystem Check | ✅ | ✅ | Verifies filesystem integrity |
| System Health Check | ✅ | ✅ | Uptime, memory, CPU, and service status |
| Performance Tweaks | ✅ | ✅ | Optimizes system settings |
| Generate Report | ✅ | ✅ | Creates detailed cleanup log |

---

## 🚀 Installation & Usage

### Linux/Ubuntu Version

#### Prerequisites
- Ubuntu 18.04 or later (or any Debian-based distribution)
- `sudo` privileges required

#### Installation
```bash
# Download the script
wget https://raw.githubusercontent.com/yourusername/merlins-cleanup/main/merlin-cleanup.sh

# Make it executable
chmod +x merlin-cleanup.sh

# Optional: Install additional tools for enhanced functionality
sudo apt update
sudo apt install -y smartmontools
```

#### Run
```bash
# Run the script
sudo ./merlin-cleanup.sh

# Or create a desktop shortcut
sudo cp merlin-cleanup.sh /usr/local/bin/merlin-cleanup
sudo chmod +x /usr/local/bin/merlin-cleanup
```

---

### Windows Version

#### Prerequisites
- Windows 10 or Windows 11
- Administrator privileges required

#### Installation
1. Download `Merlin-Cleanup.bat` from the repository
2. Right-click the file and select **"Run as administrator"**

#### Create Shortcut (Recommended)
```batch
:: Right-click the .bat file → Create shortcut
:: Right-click the shortcut → Properties → Advanced
:: Check "Run as administrator"
:: Optional: Change icon in Properties → Shortcut → Change Icon
```

---

## 🎨 Terminal Appearance

Both versions feature a distinctive **moss green background** with **cream white text** for easy reading.

```
 __       __  ________  _______   __        ______  __    __ 
/  \     /  |/        |/       \ /  |      /      |/  \  /  |
$$  \   /$$ |$$$$$$$$/ $$$$$$$  |$$ |      $$$$$$/ $$  \ $$ |
$$$  \ /$$$ |$$ |__    $$ |__$$ |$$ |        $$ |  $$$  \$$ |
$$$$  /$$$$ |$$    |   $$    $$< $$ |        $$ |  $$$$  $$ |
$$ $$ $$/$$ |$$$$$/    $$$$$$$  |$$ |        $$ |  $$ $$ $$ |
$$ |$$$/ $$ |$$ |_____ $$ |  $$ |$$ |_____  _$$ |_ $$ |$$$$ |
$$ | $/  $$ |$$       |$$ |  $$ |$$       |/ $$   |$$ | $$$ |
$$/      $$/ $$$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$/ $$/   $$/ 
                                                             
                                                             
                                                             
```

---

## 📊 Full Tune-Up Workflow

When selecting option **9 (Full Tune-Up)**, the script will:

1. Display each task name before execution
2. Prompt: `Skip 'Task Name'? [y/N]`
3. Wait 3 seconds before proceeding (unless skipped)
4. Execute the task with real-time progress
5. Continue to the next task automatically
6. Generate a final report at completion

**Example Prompt:**
```
[STEP] Next task: Clean Temporary Files
Skip 'Clean Temporary Files'? [y/N]: _
```

---

## 📝 Log Files

### Linux
- Location: `/var/log/merlin-cleanup.log`
- Contains: Timestamps, all actions, system info, disk usage before/after

### Windows
- Location: `%USERPROFILE%\Merlin-Cleanup-Log.txt`
- Contains: Date/time, user info, disk status, memory usage

---

## ⚠️ Safety & Warnings

> **IMPORTANT:** Read before using

### Linux
- **DO NOT** run on production servers without testing first
- **WILL** delete files older than 7 days in `/tmp`
- **WILL** remove old kernel versions (keeps current)
- **WILL** empty user trash (Recycle Bin equivalent)

### Windows
- **MUST** run as Administrator for most functions
- **WILL** stop Windows Update service temporarily
- **WILL** clear Event Viewer logs (Application, System, Security)
- **WILL** empty Recycle Bin without confirmation

### General
- Review the log file after each run
- Test in a virtual machine before using on primary system
- Backup important data regularly
- Some changes require reboot to take full effect

---

## 🔧 Troubleshooting

### Linux
**Issue:** "command not found: tput"
```bash
sudo apt install ncurses-base
```

**Issue:** Colors don't display correctly
```bash
# Add to ~/.bashrc
export TERM=xterm-256color
```

### Windows
**Issue:** "Access Denied" errors
- **Solution:** Right-click → "Run as administrator"

**Issue:** Terminal colors don't change
- **Solution:** Right-click CMD title bar → Properties → Colors → Set Screen Background to green (2) and Screen Text to bright white (F)

**Issue:** Some tasks complete instantly
- **Solution:** This is normal if no cleanup is needed for that category

---

## 🐛 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature-name`
5. Open a Pull Request

---

## 🔄 Changelog

### v1.0.0 (2024)
- Initial release
- Added Linux shell script
- Added Windows batch file
- Interactive menu system
- Full tune-up with skip functionality
- Comprehensive logging

---

## 👨‍💻 Author

**Merlin's Quick Clean Up** was created by Tech Merlin to simplify system maintenance for users who want a clean, efficient computer without complex commands.

For questions, issues, or suggestions, please open an issue on GitHub.

---

## ⭐ Support

If you find this helpful, please star the repository and share with others!

---

**Made with 🧙‍♂️ by the Merlin's Quick Clean Up Team**
