#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#   STGRAJ - Universal Installation Script
#   Created by: Raj Gautam
#   Version: 1.0
#   Supported: Linux, macOS, Raspberry Pi
# ═══════════════════════════════════════════════════════════════

# ==================== COLORS ====================
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ==================== FUNCTIONS ====================
print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║          STGRAJ SYSTEM MONITOR INSTALLER                 ║"
    echo "║               Created by Raj Gautam                      ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_python() {
    echo -e "${YELLOW}[*] Checking Python installation...${NC}"
    
    if command -v python3 &>/dev/null; then
        PYTHON_CMD="python3"
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
        echo -e "${GREEN}[✓] Python 3 found (version $PYTHON_VERSION)${NC}"
    elif command -v python &>/dev/null; then
        PYTHON_CMD="python"
        PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
        echo -e "${GREEN}[✓] Python found (version $PYTHON_VERSION)${NC}"
    else
        echo -e "${RED}[✗] Python not found!${NC}"
        echo -e "${YELLOW}[!] Please install Python 3.7+ first${NC}"
        exit 1
    fi
}

check_pip() {
    echo -e "${YELLOW}[*] Checking pip installation...${NC}"
    
    if command -v pip3 &>/dev/null; then
        PIP_CMD="pip3"
        echo -e "${GREEN}[✓] pip3 found${NC}"
    elif command -v pip &>/dev/null; then
        PIP_CMD="pip"
        echo -e "${GREEN}[✓] pip found${NC}"
    else
        echo -e "${RED}[✗] pip not found!${NC}"
        echo -e "${YELLOW}[!] Installing pip...${NC}"
        
        # Install pip based on platform
        if [[ "$(uname)" == "Darwin" ]]; then
            brew install python3-pip 2>/dev/null || echo -e "${RED}[✗] Please install pip manually${NC}"
        else
            sudo apt install python3-pip -y 2>/dev/null || sudo yum install python3-pip -y 2>/dev/null || sudo pacman -S python-pip -y 2>/dev/null
        fi
    fi
}

install_libraries() {
    echo -e "${YELLOW}[*] Installing required libraries...${NC}"
    
    LIBRARIES=("psutil" "rich" "pyfiglet")
    MISSING_LIBS=()
    
    # Check which libraries are missing
    for lib in "${LIBRARIES[@]}"; do
        if $PYTHON_CMD -c "import $lib" &>/dev/null; then
            echo -e "${GREEN}[✓] $lib already installed${NC}"
        else
            echo -e "${RED}[✗] $lib not found${NC}"
            MISSING_LIBS+=("$lib")
        fi
    done
    
    # Install missing libraries
    if [ ${#MISSING_LIBS[@]} -gt 0 ]; then
        echo -e "${YELLOW}[*] Installing missing libraries: ${MISSING_LIBS[*]}${NC}"
        $PIP_CMD install "${MISSING_LIBS[@]}"
        
        # Verify installation
        for lib in "${MISSING_LIBS[@]}"; do
            if $PYTHON_CMD -c "import $lib" &>/dev/null; then
                echo -e "${GREEN}[✓] $lib installed successfully${NC}"
            else
                echo -e "${RED}[✗] Failed to install $lib${NC}"
            fi
        done
    fi
}

create_files() {
    echo -e "${YELLOW}[*] Creating STGRAJ files...${NC}"
    
    # Create stgraj.py
    cat > stgraj.py << 'PYTHON_EOF'
#!/usr/bin/env python3

import os
import sys
import time
import socket
import platform
import psutil
from datetime import datetime
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.text import Text
from rich.align import Align
from rich import box
from rich.live import Live
import random

GREEN = "#00FF00"
CYAN = "#00FFFF"
AMBER = "#FFB000"
RED = "#FF4444"
WHITE = "#FFFFFF"
YELLOW = "#FFFF00"
MAGENTA = "#FF00FF"
LIGHT_GREEN = "#33FF33"

ASCII_LOGO = r"""
    ███████╗████████╗ ██████╗ ██████╗  █████╗ ██╗
    ██╔════╝╚══██╔══╝██╔════╝ ██╔══██╗██╔══██╗██║
    ███████╗   ██║   ██║  ███╗██████╔╝███████║██║
    ╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║
    ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║███████╗
    ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
"""

class STGRAJ:
    def __init__(self):
        self.console = Console()
        self.running = True
        self.sort_by = "cpu"
        self.boot_time = psutil.boot_time()
        self.hostname = socket.gethostname()
        self.user = os.getenv('USER', os.getenv('USERNAME', 'user'))
        self.last_net = psutil.net_io_counters()
        self.last_net_time = time.time()
        self.last_disk_io = psutil.disk_io_counters()
        self.last_disk_time = time.time()

    def clear_screen(self):
        os.system('cls' if os.name == 'nt' else 'clear')

    def get_uptime(self):
        try:
            uptime_sec = int(time.time() - self.boot_time)
            days = uptime_sec // 86400
            hours = (uptime_sec % 86400) // 3600
            minutes = (uptime_sec % 3600) // 60
            seconds = uptime_sec % 60
            return f"{days}d {hours:02d}:{minutes:02d}:{seconds:02d}"
        except:
            return "N/A"

    def get_cpu_percent(self):
        try:
            return psutil.cpu_percent(interval=0.1)
        except:
            return 0.0

    def get_cpu_per_core(self):
        try:
            return psutil.cpu_percent(interval=0.1, percpu=True)
        except:
            return []

    def get_cpu_freq(self):
        try:
            freq = psutil.cpu_freq()
            return freq.current if freq else 0
        except:
            return 0

    def get_load_average(self):
        try:
            if hasattr(psutil, "getloadavg"):
                return psutil.getloadavg()
            return (0.0, 0.0, 0.0)
        except:
            return (0.0, 0.0, 0.0)

    def get_memory(self):
        try:
            return psutil.virtual_memory()
        except:
            return None

    def get_swap(self):
        try:
            return psutil.swap_memory()
        except:
            return None

    def get_disk_usage(self):
        try:
            return psutil.disk_usage('/')
        except:
            return None

    def get_disk_io(self):
        try:
            current_io = psutil.disk_io_counters()
            current_time = time.time()
            time_diff = current_time - self.last_disk_time
            if time_diff > 0:
                read_speed = (current_io.read_bytes - self.last_disk_io.read_bytes) / time_diff / 1024
                write_speed = (current_io.write_bytes - self.last_disk_io.write_bytes) / time_diff / 1024
            else:
                read_speed = 0
                write_speed = 0
            self.last_disk_io = current_io
            self.last_disk_time = current_time
            return {
                'read_speed': read_speed,
                'write_speed': write_speed,
                'total_read': current_io.read_bytes / 1024**2,
                'total_write': current_io.write_bytes / 1024**2
            }
        except:
            return {'read_speed': 0, 'write_speed': 0, 'total_read': 0, 'total_write': 0}

    def get_network_speed(self):
        try:
            current_net = psutil.net_io_counters()
            current_time = time.time()
            time_diff = current_time - self.last_net_time
            if time_diff > 0:
                download = (current_net.bytes_recv - self.last_net.bytes_recv) / time_diff / 1024
                upload = (current_net.bytes_sent - self.last_net.bytes_sent) / time_diff / 1024
            else:
                download = 0
                upload = 0
            self.last_net = current_net
            self.last_net_time = current_time
            return download, upload
        except:
            return 0, 0

    def get_network_info(self):
        try:
            net = psutil.net_io_counters()
            return {
                'bytes_sent': net.bytes_sent,
                'bytes_recv': net.bytes_recv,
                'packets_sent': net.packets_sent,
                'packets_recv': net.packets_recv
            }
        except:
            return {'bytes_sent': 0, 'bytes_recv': 0, 'packets_sent': 0, 'packets_recv': 0}

    def get_processes(self):
        try:
            processes = []
            for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent', 'status', 'username', 'num_threads', 'nice', 'memory_info', 'create_time']):
                try:
                    info = proc.info
                    if info['memory_info']:
                        info['virt'] = info['memory_info'].vms / 1024 / 1024
                        info['res'] = info['memory_info'].rss / 1024 / 1024
                    else:
                        info['virt'] = 0
                        info['res'] = 0
                    info['time'] = datetime.fromtimestamp(info['create_time']).strftime("%H:%M:%S") if info['create_time'] else ""
                    info['pri'] = info['nice'] + 20 if info['nice'] else 20
                    del info['memory_info']
                    processes.append(info)
                except:
                    pass
            return processes
        except:
            return []

    def get_temperature(self):
        try:
            if hasattr(psutil, "sensors_temperatures"):
                temps = psutil.sensors_temperatures()
                if temps:
                    for name, entries in temps.items():
                        for entry in entries:
                            if entry.current:
                                return {'name': name, 'current': entry.current}
            return None
        except:
            return None

    def get_battery(self):
        try:
            if hasattr(psutil, "sensors_battery"):
                battery = psutil.sensors_battery()
                if battery:
                    return {
                        'percent': battery.percent,
                        'plugged': battery.power_plugged
                    }
            return None
        except:
            return None

    def get_users(self):
        try:
            users = []
            for user in psutil.users():
                users.append({
                    'name': user.name,
                    'terminal': user.terminal,
                    'host': user.host,
                    'started': datetime.fromtimestamp(user.started).strftime("%Y-%m-%d %H:%M:%S")
                })
            return users
        except:
            return []

    def kill_process(self, pid):
        try:
            proc = psutil.Process(pid)
            proc.terminate()
            return True, f"Process {pid} ({proc.name()}) terminated"
        except psutil.NoSuchProcess:
            return False, f"Process {pid} not found"
        except psutil.AccessDenied:
            return False, f"Access denied for process {pid}"
        except Exception as e:
            return False, f"Error: {str(e)}"

    def build_header(self):
        cpu = self.get_cpu_percent()
        mem = self.get_memory()
        load = self.get_load_average()
        temp = self.get_temperature()
        battery = self.get_battery()

        header_table = Table(show_header=False, box=None, padding=(0, 1))
        header_table.add_column("Metric", style=f"bold {CYAN}", justify="right")
        header_table.add_column("Value", style=GREEN)

        header_table.add_row("CPU", f"{cpu:.1f}%")
        header_table.add_row("RAM", f"{mem.percent:.1f}%" if mem else "N/A")
        header_table.add_row("Load", f"{load[0]:.2f} / {load[1]:.2f} / {load[2]:.2f}")

        if temp:
            header_table.add_row("Temp", f"{temp['current']:.1f}°C")
        if battery:
            header_table.add_row("Battery", f"{battery['percent']:.1f}%")

        return Panel(
            Align.center(Text(ASCII_LOGO, style=f"bold {LIGHT_GREEN}")),
            border_style=GREEN,
            box=box.DOUBLE_EDGE
        ), header_table

    def build_process_table(self):
        processes = self.get_processes()

        if self.sort_by == "cpu":
            processes = sorted(processes, key=lambda x: x['cpu_percent'] or 0, reverse=True)
        elif self.sort_by == "mem":
            processes = sorted(processes, key=lambda x: x['memory_percent'] or 0, reverse=True)
        elif self.sort_by == "pid":
            processes = sorted(processes, key=lambda x: x['pid'])
        elif self.sort_by == "name":
            processes = sorted(processes, key=lambda x: str(x['name']).lower())

        processes = processes[:25]

        table = Table(
            box=box.SIMPLE_HEAD,
            border_style=GREEN,
            header_style=f"bold {CYAN}",
            show_edge=True,
            expand=True
        )
        table.add_column("PID", style=f"bold {AMBER}", justify="right", width=8)
        table.add_column("USER", style=WHITE, width=12)
        table.add_column("PRI", justify="right", width=4)
        table.add_column("NI", justify="right", width=4)
        table.add_column("VIRT", style=GREEN, justify="right", width=8)
        table.add_column("RES", style=GREEN, justify="right", width=8)
        table.add_column("SHR", style=GREEN, justify="right", width=8)
        table.add_column("GPU%", style=MAGENTA, justify="right", width=6)
        table.add_column("MEM%", style=AMBER, justify="right", width=6)
        table.add_column("TIME", style=CYAN, width=8)
        table.add_column("COMMAND", style=GREEN)

        for p in processes:
            cpu = p['cpu_percent'] or 0
            mem_p = p['memory_percent'] or 0
            pri = p.get('pri', 20)
            ni = p.get('nice', 0)
            virt = p.get('virt', 0)
            res = p.get('res', 0)
            shr = res * 0.7
            gpu = 0.0
            time_str = p.get('time', '')

            cpu_style = RED if cpu > 50 else (AMBER if cpu > 20 else GREEN)
            mem_style = RED if mem_p > 50 else (AMBER if mem_p > 20 else GREEN)

            table.add_row(
                str(p['pid']),
                str(p['username'] or 'root')[:12],
                str(pri),
                str(ni),
                f"{virt:.0f}M",
                f"{res:.0f}M",
                f"{shr:.0f}M",
                f"{gpu:.1f}",
                f"[{mem_style}]{mem_p:.1f}[/{mem_style}]",
                time_str,
                f"[{cpu_style}]{str(p['name'])[:30]}[/{cpu_style}]"
            )

        return Panel(table, border_style=GREEN, box=box.ROUNDED, title=f"[bold green]📋 PROCESSES ({self.sort_by.upper()})[/bold green]")

    def build_info_panels(self):
        cpu = self.get_cpu_percent()
        mem = self.get_memory()
        swap = self.get_swap()
        disk = self.get_disk_usage()
        disk_io = self.get_disk_io()
        download, upload = self.get_network_speed()
        net_info = self.get_network_info()
        load = self.get_load_average()
        temp = self.get_temperature()
        battery = self.get_battery()
        users = self.get_users()

        info_table = Table(show_header=False, box=None, padding=(0, 1))
        info_table.add_column("Metric", style=f"bold {CYAN}", justify="right")
        info_table.add_column("Value", style=GREEN)

        info_table.add_row("Hostname", self.hostname)
        info_table.add_row("Platform", f"{platform.system()} {platform.release()}")
        info_table.add_row("Uptime", self.get_uptime())
        info_table.add_row("User", self.user)

        info_table.add_row("")
        info_table.add_row("CPU Load", f"{cpu:.1f}%")
        info_table.add_row("Load Avg", f"{load[0]:.2f} / {load[1]:.2f} / {load[2]:.2f}")
        if temp:
            info_table.add_row("Temp", f"{temp['current']:.1f}°C")
        if battery:
            info_table.add_row("Battery", f"{battery['percent']:.1f}% {'🔌' if battery['plugged'] else '🔋'}")

        info_table.add_row("")
        info_table.add_row("RAM Used", f"{mem.used / 1024**3:.2f} GB / {mem.total / 1024**3:.2f} GB ({mem.percent:.1f}%)" if mem else "N/A")
        if swap:
            info_table.add_row("Swap", f"{swap.used / 1024**3:.2f} GB / {swap.total / 1024**3:.2f} GB ({swap.percent:.1f}%)")

        info_table.add_row("")
        info_table.add_row("Disk Used", f"{disk.used / 1024**3:.2f} GB / {disk.total / 1024**3:.2f} GB ({disk.percent:.1f}%)" if disk else "N/A")
        info_table.add_row("Disk Read", f"{disk_io['read_speed']:.2f} KB/s")
        info_table.add_row("Disk Write", f"{disk_io['write_speed']:.2f} KB/s")

        info_table.add_row("")
        info_table.add_row("Download", f"{download:.2f} KB/s")
        info_table.add_row("Upload", f"{upload:.2f} KB/s")
        info_table.add_row("Total Down", f"{net_info['bytes_recv'] / 1024**2:.2f} MB")
        info_table.add_row("Total Up", f"{net_info['bytes_sent'] / 1024**2:.2f} MB")

        info_panel = Panel(info_table, border_style=CYAN, box=box.ROUNDED, title="[bold cyan]📊 SYSTEM INFO[/bold cyan]")

        user_table = Table(show_header=False, box=None)
        user_table.add_column("User", style=f"bold {CYAN}")
        user_table.add_column("Terminal", style=GREEN)
        user_table.add_column("Started", style=GREEN)

        for user in users:
            user_table.add_row(user['name'], user['terminal'], user['started'])

        user_panel = Panel(user_table, border_style=MAGENTA, box=box.ROUNDED, title="[bold magenta]👤 USERS[/bold magenta]") if users else None

        return info_panel, user_panel

    def build_controls(self):
        controls = Table(show_header=False, box=None)
        controls.add_column("Key", style=f"bold {AMBER}", justify="right")
        controls.add_column("Action", style=GREEN)
        controls.add_row("[Q]", "Quit")
        controls.add_row("[1]", "Sort CPU")
        controls.add_row("[2]", "Sort MEM")
        controls.add_row("[3]", "Sort PID")
        controls.add_row("[4]", "Sort Name")
        controls.add_row("[M]", "Matrix")
        controls.add_row("[K]", "Kill Process")

        return Panel(controls, border_style=YELLOW, box=box.ROUNDED, title="[bold yellow]🎮 CONTROLS[/bold yellow]")

    def generate_content(self):
        from rich.console import Group

        logo_panel, header_table = self.build_header()
        info_panel, user_panel = self.build_info_panels()
        proc_panel = self.build_process_table()
        controls_panel = self.build_controls()

        renderables = [
            logo_panel,
            Text(""),
            header_table,
            Text(""),
            info_panel,
            Text(""),
        ]

        if user_panel:
            renderables.extend([user_panel, Text("")])

        renderables.extend([
            proc_panel,
            Text(""),
            controls_panel
        ])

        return Group(*renderables)

    def matrix_effect(self, duration=3):
        self.clear_screen()

        green = "\033[92m"
        bright = "\033[92m\033[1m"
        reset = "\033[0m"
        chars = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789ABCDEF<>#$%&*+-/=?"

        try:
            cols = os.get_terminal_size().columns
            rows = os.get_terminal_size().lines
        except:
            cols, rows = 80, 24

        drops = [0] * cols
        start = time.time()

        while time.time() - start < duration:
            output = []
            for i in range(cols):
                if drops[i] > 0 and random.random() > 0.975:
                    drops[i] = 0
                if random.random() > 0.999:
                    drops[i] = random.randint(0, rows)
                if i == 0 or random.random() > 0.995:
                    drops[i] += 1
                if drops[i] > rows:
                    drops[i] = 0
                if drops[i] > 0:
                    output.append(f"{bright}{random.choice(chars)}{reset}")
                else:
                    output.append(" ")

            print(f"\033[{rows}A\033[0J", end="")
            print("".join(output))
            time.sleep(0.05)

    def boot_sequence(self):
        self.clear_screen()

        self.console.print(Panel(
            Align.center(Text(ASCII_LOGO, style=f"bold {LIGHT_GREEN}")),
            border_style=GREEN,
            box=box.DOUBLE_EDGE,
            padding=(1, 2)
        ))
        self.console.print("")

        self.console.print(Align.center(Text(f"Welcome, {self.user}! Initializing STGRAJ Monitor...", style=f"bold {CYAN}")))

        boot_messages = [
            "[OK] Loading System Monitor...",
            "[OK] Loading Process Table...",
            "[OK] All Systems Ready!",
        ]

        for msg in boot_messages:
            self.console.print(f"[green]{msg}[/green]")
            time.sleep(0.3)

        time.sleep(0.5)

    def run(self):
        self.boot_sequence()

        with Live(
            self.generate_content(),
            console=self.console,
            refresh_per_second=1,
            screen=False
        ) as live:
            while self.running:
                live.update(self.generate_content())

                import select
                choice = ""

                if os.name == 'nt':
                    try:
                        import msvcrt
                        if msvcrt.kbhit():
                            choice = msvcrt.getch().decode().lower()
                    except:
                        pass
                else:
                    r, _, _ = select.select([sys.stdin], [], [], 0.5)
                    if r:
                        choice = sys.stdin.read(1).lower()

                if choice == 'q':
                    self.running = False
                elif choice == '1':
                    self.sort_by = "cpu"
                elif choice == '2':
                    self.sort_by = "mem"
                elif choice == '3':
                    self.sort_by = "pid"
                elif choice == '4':
                    self.sort_by = "name"
                elif choice == 'm':
                    live.stop()
                    self.matrix_effect(3)
                    live.start()
                elif choice == 'k':
                    live.stop()
                    self.console.print(f"\n[{CYAN}]Enter PID to kill: [/{CYAN}]", end="")
                    pid_input = input().strip()
                    if pid_input.isdigit():
                        success, msg = self.kill_process(int(pid_input))
                        if success:
                            self.console.print(f"[{GREEN}]✔ {msg}[/{GREEN}]")
                        else:
                            self.console.print(f"[{RED}]✘ {msg}[/{RED}]")
                        time.sleep(1.5)
                    live.start()

                time.sleep(0.5)

        self.clear_screen()
        self.console.print(f"\n[{GREEN}]STGRAJ Monitor terminated. Goodbye![/{GREEN}]")
        self.console.print(f"[{CYAN}]Created by Raj Gautam[/{CYAN}]")
        time.sleep(1.5)

if __name__ == "__main__":
    try:
        app = STGRAJ()
        app.run()
    except KeyboardInterrupt:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"\n[GREEN]STGRAJ stopped by user. Goodbye![/{GREEN}]")
        print(f"[CYAN]Created by Raj Gautam[/{CYAN}]")
        sys.exit(0)
    except Exception as e:
        print(f"\n[RED]Error: {str(e)}[/RED]")
        print(f"[YELLOW]Try running with: python3 stgraj.py[/YELLOW]")
        sys.exit(1)
PYTHON_EOF

    # Make executable
    chmod +x stgraj.py
    echo -e "${GREEN}[✓] stgraj.py created${NC}"
}

create_install_config() {
    echo -e "${YELLOW}[*] Creating install_config.json...${NC}"
    
    cat > install_config.json << 'JSON_EOF'
{
  "tool_name": "STGRAJ",
  "version": "3.2.0",
  "author": "Raj Gautam",
  "platforms": {
    "linux": {
      "name": "Linux",
      "requirements": {
        "python_version": ">=3.7",
        "libraries": ["psutil", "rich", "pyfiglet"]
      },
      "installation": {
        "steps": [
          {"step": 1, "command": "sudo apt update", "description": "Update packages"},
          {"step": 2, "command": "sudo apt install python3 python3-pip -y", "description": "Install Python"},
          {"step": 3, "command": "pip3 install psutil rich pyfiglet", "description": "Install libraries"},
          {"step": 4, "command": "chmod +x stgraj.py", "description": "Make executable"},
          {"step": 5, "command": "python3 stgraj.py", "description": "Run monitor"}
        ]
      }
    },
    "windows": {
      "name": "Windows",
      "requirements": {
        "python_version": ">=3.7",
        "libraries": ["psutil", "rich", "pyfiglet"]
      },
      "installation": {
        "steps": [
          {"step": 1, "command": "winget install Python.Python.3.11", "description": "Install Python"},
          {"step": 2, "command": "pip install psutil rich pyfiglet", "description": "Install libraries"},
          {"step": 3, "command": "python stgraj.py", "description": "Run monitor"}
        ]
      }
    },
    "raspberry_pi": {
      "name": "Raspberry Pi",
      "requirements": {
        "python_version": ">=3.7",
        "libraries": ["psutil", "rich", "pyfiglet"]
      },
      "installation": {
        "steps": [
          {"step": 1, "command": "sudo apt update", "description": "Update packages"},
          {"step": 2, "command": "sudo apt install python3 python3-pip -y", "description": "Install Python"},
          {"step": 3, "command": "pip3 install psutil rich pyfiglet", "description": "Install libraries"},
          {"step": 4, "command": "chmod +x stgraj.py", "description": "Make executable"},
          {"step": 5, "command": "python3 stgraj.py", "description": "Run monitor"}
        ]
      }
    },
    "macos": {
      "name": "macOS",
      "requirements": {
        "python_version": ">=3.7",
        "libraries": ["psutil", "rich", "pyfiglet"]
      },
      "installation": {
        "steps": [
          {"step": 1, "command": "brew install python3", "description": "Install Python"},
          {"step": 2, "command": "pip3 install psutil rich pyfiglet", "description": "Install libraries"},
          {"step": 3, "command": "chmod +x stgraj.py", "description": "Make executable"},
          {"step": 4, "command": "python3 stgraj.py", "description": "Run monitor"}
        ]
      }
    }
  }
}
JSON_EOF

    echo -e "${GREEN}[✓] install_config.json created${NC}"
}

show_completion() {
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          INSTALLATION COMPLETE!                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[✓] Python: $PYTHON_VERSION${NC}"
    echo -e "${CYAN}[✓] Libraries: psutil, rich, pyfiglet${NC}"
    echo -e "${CYAN}[✓] Files: stgraj.py, install_config.json${NC}"
    echo -e "${CYAN}[✓] Permissions: executable${NC}"
    
    echo -e "\n${YELLOW}[*] To run STGRAJ:${NC}"
    echo -e "${GREEN}    python3 stgraj.py${NC}"
    
    echo -e "\n${MAGENTA}[*] Installation completed by Raj Gautam${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════════════${NC}\n"
}

# ==================== MAIN SCRIPT ====================
main() {
    print_header
    check_python
    check_pip
    install_libraries
    create_files
    create_install_config
    show_completion
}

# Run main
main