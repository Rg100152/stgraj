@echo off
:: ═══════════════════════════════════════════════════════════════
::   STGRAJ - One-Click Setup and Run
::   Created by: Raj Gautam
:: ═══════════════════════════════════════════════════════════════

:: Set colors
set GREEN=[92m
set RED=[91m
set YELLOW=[93m
set CYAN=[96m
set MAGENTA=[95m
set NC=[0m

:: Clear screen
cls

:: Header
echo.
echo %CYAN%╔══════════════════════════════════════════════════════════╗%NC%
echo %CYAN%║          STGRAJ - SETUP AND RUN                          ║%NC%
echo %CYAN%║               Created by Raj Gautam                      ║%NC%
echo %CYAN%╚══════════════════════════════════════════════════════════╝%NC%
echo.

:: Check Python
echo %YELLOW%[*] Checking Python...%NC%
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%[X] Python not found!%NC%
    echo %YELLOW%[!] Please install Python from python.org%NC%
    start https://www.python.org/downloads/
    pause
    exit /b 1
)
echo %GREEN%[OK] Python found%NC%

:: Install libraries
echo.
echo %YELLOW%[*] Checking libraries...%NC%
python -c "import psutil, rich, pyfiglet" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[!] Installing libraries...%NC%
    python -m pip install psutil rich pyfiglet
    echo %GREEN%[OK] Libraries installed%NC%
) else (
    echo %GREEN%[OK] Libraries already installed%NC%
)

:: Run STGRAJ
echo.
echo %GREEN%[OK] Starting STGRAJ...%NC%
echo.
python stgraj.py