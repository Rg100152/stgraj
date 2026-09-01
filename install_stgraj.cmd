@echo off
:: ═══════════════════════════════════════════════════════════════
::   STGRAJ - Windows Installation Script
::   Created by: Raj Gautam
::   Version: 1.0
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
echo %CYAN%║          STGRAJ SYSTEM MONITOR INSTALLER                 ║%NC%
echo %CYAN%║               Created by Raj Gautam                      ║%NC%
echo %CYAN%╚══════════════════════════════════════════════════════════╝%NC%
echo.
echo %YELLOW%[*] Checking Python installation...%NC%

:: Check Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%[X] Python not found!%NC%
    echo %YELLOW%[!] Please install Python 3.7+ from python.org%NC%
    echo.
    echo %YELLOW%[!] Opening Python download page...%NC%
    start https://www.python.org/downloads/
    pause
    exit /b 1
)

:: Get Python version
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set PYTHON_VERSION=%%v
echo %GREEN%[OK] Python found (version %PYTHON_VERSION%)%NC%

:: Check pip
echo.
echo %YELLOW%[*] Checking pip installation...%NC%
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%[X] pip not found!%NC%
    echo %YELLOW%[!] Installing pip...%NC%
    python -m ensurepip --upgrade
)

echo %GREEN%[OK] pip found%NC%

:: Install libraries
echo.
echo %YELLOW%[*] Installing required libraries...%NC%

:: Check psutil
python -c "import psutil" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[!] Installing psutil...%NC%
    python -m pip install psutil
) else (
    echo %GREEN%[OK] psutil already installed%NC%
)

:: Check rich
python -c "import rich" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[!] Installing rich...%NC%
    python -m pip install rich
) else (
    echo %GREEN%[OK] rich already installed%NC%
)

:: Check pyfiglet
python -c "import pyfiglet" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[!] Installing pyfiglet...%NC%
    python -m pip install pyfiglet
) else (
    echo %GREEN%[OK] pyfiglet already installed%NC%
)

:: Create stgraj.py
echo.
echo %YELLOW%[*] Creating stgraj.py...%NC%

copy /y "%~dp0stgraj.py" "stgraj.py" >nul 2>&1
if exist "stgraj.py" (
    echo %GREEN%[OK] stgraj.py ready%NC%
) else (
    echo %RED%[X] stgraj.py not found!%NC%
    echo %YELLOW%[!] Please make sure stgraj.py is in the same folder%NC%
    pause
    exit /b 1
)

:: Create install_config.json
echo.
echo %YELLOW%[*] Creating install_config.json...%NC%

if exist "install_config.json" (
    echo %GREEN%[OK] install_config.json ready%NC%
) else (
    echo %YELLOW%[!] Creating install_config.json...%NC%
    (
        echo {
        echo   "tool_name": "STGRAJ",
        echo   "version": "3.2.0",
        echo   "author": "Raj Gautam",
        echo   "platforms": {
        echo     "windows": {
        echo       "name": "Windows",
        echo       "requirements": {
        echo         "python_version": ">=3.7",
        echo         "libraries": ["psutil", "rich", "pyfiglet"]
        echo       },
        echo       "installation": {
        echo         "steps": [
        echo           {"step": 1, "command": "python -m pip install psutil rich pyfiglet", "description": "Install libraries"},
        echo           {"step": 2, "command": "python stgraj.py", "description": "Run monitor"}
        echo         ]
        echo       }
        echo     }
        echo   }
        echo }
    ) > install_config.json
    echo %GREEN%[OK] install_config.json created%NC%
)

:: Show completion
echo.
echo %GREEN%╔══════════════════════════════════════════════════════════╗%NC%
echo %GREEN%║          INSTALLATION COMPLETE!                          ║%NC%
echo %GREEN%╚══════════════════════════════════════════════════════════╝%NC%
echo.
echo %CYAN%[OK] Python: %PYTHON_VERSION%%NC%
echo %CYAN%[OK] Libraries: psutil, rich, pyfiglet%NC%
echo %CYAN%[OK] Files: stgraj.py, install_config.json%NC%
echo.
echo %YELLOW%[*] To run STGRAJ:%NC%
echo %GREEN%    python stgraj.py%NC%
echo.
echo %MAGENTA%[*] Installation completed by Raj Gautam%NC%
echo.

:: Ask to run
set /p RUN_STGRAJ="Run STGRAJ now? (y/n): "
if /i "%RUN_STGRAJ%"=="y" (
    python stgraj.py
)

pause