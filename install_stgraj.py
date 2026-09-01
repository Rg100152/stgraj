#!/usr/bin/env python3
"""
STGRAJ Installation Helper
Created by Raj Gautam
"""

import json
import os
import platform
import subprocess
import sys

def load_config():
    with open('install_config.json', 'r') as f:
        return json.load(f)

def detect_platform():
    system = platform.system().lower()
    
    if system == 'linux':
        # Check for Raspberry Pi
        if os.path.exists('/proc/device-tree/model'):
            with open('/proc/device-tree/model', 'r') as f:
                model = f.read()
                if 'raspberry' in model.lower():
                    return 'raspberry_pi'
        return 'linux'
    elif system == 'windows':
        return 'windows'
    elif system == 'darwin':
        return 'macos'
    else:
        return 'unknown'

def print_header(config):
    print("=" * 70)
    print(f"  {config['tool_name']} v{config['version']} - Installation Helper")
    print(f"  Author: {config['author']}")
    print("=" * 70)
    print()

def get_installation_steps(config, platform_name):
    platform_config = config['platforms'].get(platform_name)
    if not platform_config:
        return None
    
    steps = platform_config['installation']['steps']
    return steps

def check_libraries():
    """Check if required libraries are installed"""
    libraries = ['psutil', 'rich', 'pyfiglet']
    installed = []
    missing = []
    
    for lib in libraries:
        try:
            __import__(lib)
            installed.append(lib)
        except ImportError:
            missing.append(lib)
    
    return installed, missing

def print_installation_guide(config, platform_name):
    platform_config = config['platforms'][platform_name]
    
    print(f"[*] Detected Platform: {platform_config['name']}")
    print(f"[*] Python Required: {platform_config['requirements']['python_version']}")
    print(f"[*] Required Libraries: {', '.join(platform_config['requirements']['libraries'])}")
    print()
    
    print("Installation Steps:")
    print("-" * 70)
    
    steps = platform_config['installation']['steps']
    for step in steps:
        print(f"\n  Step {step['step']}: {step['description']}")
        print(f"    Command: {step['command']}")
    
    print()
    print("-" * 70)
    
    # Alternative methods
    alt_methods = platform_config['installation'].get('alt_methods', {})
    if alt_methods:
        print("\nAlternative Methods:")
        for method, command in alt_methods.items():
            print(f"  {method}: {command}")
    
    print()

def main():
    config = load_config()
    print_header(config)
    
    # Detect platform
    platform_name = detect_platform()
    
    if platform_name == 'unknown':
        print("[!] Unable to detect platform. Please check manually.")
        sys.exit(1)
    
    # Print installation guide
    print_installation_guide(config, platform_name)
    
    # Check libraries
    print("\n[+] Checking libraries...")
    installed, missing = check_libraries()
    
    if installed:
        print(f"[✓] Installed: {', '.join(installed)}")
    
    if missing:
        print(f"[✗] Missing: {', '.join(missing)}")
        print("\n[!] Please install missing libraries:")
        print(f"    pip install {' '.join(missing)}")
    
    print()
    
    # Show controls
    print("\n[+] STGRAJ Controls:")
    controls = config['features']['controls']
    for action, key in controls.items():
        print(f"    [{key}] - {action.replace('_', ' ').title()}")
    
    print()
    print("=" * 70)
    print(f"  Thank you for using {config['tool_name']}!")
    print("=" * 70)

if __name__ == '__main__':
    main()