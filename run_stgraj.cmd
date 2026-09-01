@echo off
:: ═══════════════════════════════════════════════════════════════
::   STGRAJ - Quick Run Script
::   Created by: Raj Gautam
:: ═══════════════════════════════════════════════════════════════

:: Set colors
set GREEN=[92m
set RED=[91m
set YELLOW=[93m
set CYAN=[96m
set NC=[0m

:: Clear screen
cls

:: Check if stgraj.py exists
if not exist "stgraj.py" (
    echo %RED%[X] stgraj.py not found!%NC%
    echo %YELLOW%[!] Please run install_stgraj.cmd first%NC%
    pause
    exit /b 1
)

:: Check if libraries are installed
python -c "import psutil, rich, pyfiglet" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[!] Libraries not installed. Installing...%NC%
    python -m pip install psutil rich pyfiglet
)

:: Run STGRAJ
echo %GREEN%[OK] Starting STGRAJ...%NC%
python stgraj.py