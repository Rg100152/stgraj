
<div align="center">

# 🖥️ STGRAJ - System Monitor

![STGRAJ Logo](https://raw.githubusercontent.com/Rg100152/stgraj/main/assets/stgraj_logo.png)

**Advanced System Monitor with htop-style interface & Cyberpunk UI**

[![GitHub stars](https://img.shields.io/github/stars/Rg100152/stgraj?style=for-the-badge&color=00FF00)](https://github.com/Rg100152/stgraj/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Rg100152/stgraj?style=for-the-badge&color=00FF00)](https://github.com/Rg100152/stgraj/network)
[![GitHub issues](https://img.shields.io/github/issues/Rg100152/stgraj?style=for-the-badge&color=00FF00)](https://github.com/Rg100152/stgraj/issues)
[![GitHub license](https://img.shields.io/github/license/Rg100152/stgraj?style=for-the-badge&color=00FF00)](https://github.com/Rg100152/stgraj/blob/main/LICENSE)

![Python Version](https://img.shields.io/badge/Python-3.7%2B-blue?style=for-the-badge&logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows%20%7C%20macOS%20%7C%20Raspberry%20Pi-brightgreen?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
![Maintenance](https://img.shields.io/badge/Maintained-Yes-brightgreen?style=for-the-badge)

</div>

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Installation](#-installation)
- [Usage](#-usage)
- [Controls](#-controls)
- [Process Table](#-process-table)
- [Supported Platforms](#-supported-platforms)
- [Contributing](#-contributing)
- [License](#-license)
- [Author](#-author)

---

## ✨ Features

### 🖥️ System Monitoring
| Feature | Description |
|---------|-------------|
| **CPU** | Total usage, per-core usage, frequency, temperature |
| **Memory** | RAM usage, swap usage, available memory |
| **Disk** | Usage, read/write speed, partitions |
| **Network** | Download/upload speed, total traffic |
| **Processes** | Full process table with all details |
| **Load Average** | 1/5/15 min load |
| **Battery** | Status & percentage (laptops) |
| **Users** | Currently logged in users |

### 🎨 Cyberpunk UI
- Matrix green theme
- ASCII art logo
- Real-time updates
- Smooth animations
- htop-style interface

### 🎮 Interactive Controls
- Sort by CPU/Memory/PID/Name
- Kill processes
- Matrix rain effect
- Real-time refresh

---

## 📸 Screenshots

<div align="center">

### Main Interface
![Main Interface](https://raw.githubusercontent.com/Rg100152/stgraj/main/screenshots/main.png)

### Process Table
![Process Table](https://raw.githubusercontent.com/Rg100152/stgraj/main/screenshots/processes.png)

### Matrix Effect
![Matrix Effect](https://raw.githubusercontent.com/Rg100152/stgraj/main/screenshots/matrix.png)

</div>

---

## 🚀 Installation

### One-Line Installer (Linux/macOS)
```bash
curl -sL https://raw.githubusercontent.com/Rg100152/stgraj/main/install_stgraj.sh | bash
```

### Windows Installer
```cmd
# Download and run
install_stgraj.cmd
```

### Manual Installation

#### Linux (Ubuntu/Debian)
```bash
# 1. Update packages
sudo apt update && sudo apt upgrade -y

# 2. Install Python
sudo apt install python3 python3-pip -y

# 3. Install required libraries
pip3 install psutil rich pyfiglet

# 4. Clone repository
git clone https://github.com/Rg100152/stgraj.git
cd stgraj

# 5. Make script executable
chmod +x stgraj.py

# 6. Run STGRAJ
python3 stgraj.py
```

#### Windows
```powershell
# 1. Install Python 3.11+
winget install Python.Python.3.11

# 2. Install required libraries
pip install psutil rich pyfiglet

# 3. Clone repository
git clone https://github.com/Rg100152/stgraj.git
cd stgraj

# 4. Run STGRAJ
python stgraj.py
```

#### macOS
```bash
# 1. Install Python via Homebrew
brew install python3

# 2. Install required libraries
pip3 install psutil rich pyfiglet

# 3. Clone repository
git clone https://github.com/Rg100152/stgraj.git
cd stgraj

# 4. Make script executable
chmod +x stgraj.py

# 5. Run STGRAJ
python3 stgraj.py
```

#### Raspberry Pi
```bash
# 1. Update packages
sudo apt update

# 2. Install Python
sudo apt install python3 python3-pip -y

# 3. Install required libraries
pip3 install psutil rich pyfiglet

# 4. Clone repository
git clone https://github.com/Rg100152/stgraj.git
cd stgraj

# 5. Make script executable
chmod +x stgraj.py

# 6. Run STGRAJ
python3 stgraj.py
```

---

## 🎯 Usage

```bash
# Run STGRAJ
python3 stgraj.py

# Run with auto-refresh (every second)
python3 stgraj.py --refresh 1

# Run with specific sort
python3 stgraj.py --sort cpu
```

---

## 🎮 Controls

| Key | Action |
|-----|--------|
| `Q` | Quit |
| `1` | Sort by CPU |
| `2` | Sort by Memory |
| `3` | Sort by PID |
| `4` | Sort by Name |
| `M` | Matrix Rain Effect |
| `K` | Kill Process |

---

## 📊 Process Table

```
╔══════════════════════════════════════════════════════════════════╗
║                          STGRAJ MONITOR                          ║
╠══════════════════════════════════════════════════════════════════╣
║  CPU: 45.2%  |  RAM: 30.5%  |  Load: 0.45 0.32 0.21            ║
╠══════════════════════════════════════════════════════════════════╣
║  PID    USER         PRI  NI  VIRT    RES     SHR    GPU%  MEM%  ║
║  1234   root         20   0   1250M   456M    319M   0.0   3.2   ║
║  5678   raj          20   0   890M     234M    164M   0.0   1.5   ║
║  9012   system       20   0   345M     89M     62M    0.0   0.8   ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🖥️ Supported Platforms

| Platform | Support |
|----------|---------|
| **Linux** (Ubuntu, Debian, Fedora, Arch, Pop!_OS) | ✅ |
| **Windows** (10, 11) | ✅ |
| **macOS** (Catalina+) | ✅ |
| **Raspberry Pi** (4, 5, Zero 2) | ✅ |

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) first.

### How to Contribute

1. **Fork** the repository
2. **Create** a new branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Development Setup
```bash
# Clone the repository
git clone https://github.com/Rg100152/stgraj.git
cd stgraj

# Install dev dependencies
pip install -r requirements-dev.txt

# Run tests
pytest tests/
```

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

<div align="center">

**Raj Gautam**

[![GitHub](https://img.shields.io/badge/GitHub-Rg100152-blue?style=for-the-badge&logo=github)](https://github.com/Rg100152)
[![Email](https://img.shields.io/badge/Email-rajgautam%40gmail.com-red?style=for-the-badge&logo=gmail)](mailto:rajgautam@gmail.com)

**Created with ❤️ for developers**

</div>

---

<div align="center">

## ⭐ Star this repository!

If you find STGRAJ useful, please consider starring the repository.

[![GitHub stars](https://img.shields.io/github/stars/Rg100152/stgraj?style=social)](https://github.com/Rg100152/stgraj/stargazers)

</div>

---

<div align="center">

**Made with 🔥 by Raj Gautam**

</div>
```

---

## 📁 GitHub Repo Structure

```
stgraj/
├── README.md                 # Main README (abhi bana)
├── CONTRIBUTING.md           # Contributing guide
├── CODE_OF_CONDUCT.md        # Code of conduct
├── LICENSE                   # MIT License
├── .gitignore                # Git ignore file
├── requirements.txt          # Production dependencies
├── requirements-dev.txt      # Development dependencies
├── install.sh                # Quick installer (Linux/macOS)
├── install_stgraj.cmd        # Windows installer
├── setup.bat                 # Windows setup + run
├── run_stgraj.cmd            # Windows quick run
├── stgraj.py                 # Main tool
├── pyproject.toml            # TOML configuration
├── install_config.json       # Configuration file
├── assets/                   # Images
│   └── stgraj_logo.png
├── screenshots/              # Screenshots
│   ├── main.png
│   ├── processes.png
│   └── matrix.png
├── tests/                    # Test files
│   └── test_stgraj.py
└── .github/
    ├── ISSUE_TEMPLATE/
    │   ├── bug_report.md
    │   └── feature_request.md
    └── PULL_REQUEST_TEMPLATE.md
```

---

## 🚀 GitHub Push Commands

```bash
# Initialize git
git init

# Add all files
git add .

# First commit
git commit -m "Initial commit: STGRAJ System Monitor v3.2"

# Add remote
git remote add origin https://github.com/Rg100152/stgraj.git

# Push to GitHub
git push -u origin main
```

---

## ✅ README Features

| Feature | Description |
|---------|-------------|
| **Badges** | Stars, forks, issues, license, Python version |
| **Features** | Sab system monitoring features |
| **Screenshots** | Images placeholders |
| **Installation** | Linux, Windows, macOS, Raspberry Pi |
| **Usage** | Commands with examples |
| **Controls** | Keyboard shortcuts |
| **Process Table** | Example output |
| **Contributing** | How to contribute |
| **License** | MIT license |
| **Author** | Raj Gautam with GitHub link |

---

