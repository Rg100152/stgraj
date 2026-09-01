@echo off
:: ═══════════════════════════════════════════════════════════════
::   STGRAJ - Uninstall Script
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

:: Header
echo.
echo %CYAN%╔══════════════════════════════════════════════════════════╗%NC%
echo %CYAN%║          STGRAJ UNINSTALLER                              ║%NC%
echo %CYAN%╚══════════════════════════════════════════════════════════╝%NC%
echo.

:: Confirm
set /p CONFIRM="Are you sure you want to uninstall STGRAJ? (y/n): "
if /i not "%CONFIRM%"=="y" (
    echo %YELLOW%[!] Uninstall cancelled%NC%
    pause
    exit /b 0
)

:: Remove files
echo %YELLOW%[*] Removing files...%NC%

if exist "stgraj.py" (
    del /f "stgraj.py"
    echo %GREEN%[OK] stgraj.py removed%NC%
)

if exist "install_config.json" (
    del /f "install_config.json"
    echo %GREEN%[OK] install_config.json removed%NC%
)

if exist "pyproject.toml" (
    del /f "pyproject.toml"
    echo %GREEN%[OK] pyproject.toml removed%NC%
)

if exist "README.md" (
    del /f "README.md"
    echo %GREEN%[OK] README.md removed%NC%
)

:: Optional: Uninstall libraries
set /p UNINSTALL_LIBS="Uninstall libraries too? (y/n): "
if /i "%UNINSTALL_LIBS%"=="y" (
    echo %YELLOW%[*] Uninstalling libraries...%NC%
    python -m pip uninstall psutil rich pyfiglet -y
    echo %GREEN%[OK] Libraries uninstalled%NC%
)

echo.
echo %GREEN%[OK] STGRAJ uninstalled successfully!%NC%
echo %CYAN%Created by Raj Gautam%NC%
echo.

pause