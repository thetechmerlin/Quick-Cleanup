@echo off
setlocal enabledelayedexpansion

:: ==============================================================================
:: MERLIN'S QUICK CLEAN UP - Windows System Maintenance Script
:: ==============================================================================
:: A user-friendly system cleaner with interactive menu and full automation options
:: ==============================================================================

:: Set terminal colors - Dark green background, cream white text
:: Note: Windows CMD has limited color palette - using closest available
color 20

:: Set log file location
set LOG_FILE=%USERPROFILE%\Merlin-Cleanup-Log.txt
echo Merlin's Quick Clean Up - Log File Created: %DATE% %TIME% > "%LOG_FILE%"
echo User: %USERNAME% >> "%LOG_FILE%"
echo Computer: %COMPUTERNAME% >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script requires Administrator privileges.
    echo [ERROR] Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: ==============================================================================
:: HELPER FUNCTIONS
:: ==============================================================================

:log_message
echo [%DATE% %TIME%] %~1 >> "%LOG_FILE%"
exit /b 0

:print_header
echo.
echo ========================================
echo %~1
echo ========================================
call :log_message "HEADER: %~1"
exit /b 0

:print_step
echo [STEP] %~1
call :log_message "STEP: %~1"
exit /b 0

:print_success
echo [SUCCESS] %~1
call :log_message "SUCCESS: %~1"
exit /b 0

:print_warning
echo [WARNING] %~1
call :log_message "WARNING: %~1"
exit /b 0

:print_error
echo [ERROR] %~1
call :log_message "ERROR: %~1"
exit /b 0

:ask_user
set /p response="%~1 [Y/n]: "
if /i "%response%"=="n" exit /b 1
if /i "%response%"=="no" exit /b 1
exit /b 0

:skip_prompt
set /p skip="Skip '%~1'? [y/N]: "
if /i "%skip%"=="y" exit /b 0
if /i "%skip%"=="yes" exit /b 0
exit /b 1

:show_progress
echo|set /p="."
ping localhost -n 2 >nul
echo|set /p="."
ping localhost -n 2 >nul
echo|set /p="."
ping localhost -n 2 >nul
echo.
exit /b 0

:: ==============================================================================
:: ASCII ART SPLASH SCREEN
:: ==============================================================================

:show_splash
cls
echo.
echo  __    __   __   __  ___       ___  __   __   ___      ___
echo ^|  \/  ^| ^|__^| ^|__^|  ^|   ^|  ^| ^|__  ^|__^| ^|__^| ^|__  ^|^\ ^|  ^|  
echo ^|      ^| ^|  ^| ^|  ^|  ^|   ^|__^| ^|___ ^|  ^| ^|    ^|___ ^| ^\^ ^|  ^|  
echo.
echo Initializing Merlin's Quick Clean Up...
timeout /t 3 /nobreak >nul
cls
exit /b 0

:: ==============================================================================
:: CORE CLEANUP TASKS
:: ==============================================================================

:clean_temp_files
call :print_header "TASK: Clean Temporary Files"
call :print_step "Cleaning user temp folders..."
del /s /q "%TEMP%\*.*" >nul 2>&1
del /s /q "%TMP%\*.*" >nul 2>&1
del /s /q "%USERPROFILE%\AppData\Local\Temp\*.*" >nul 2>&1
call :show_progress
call :print_success "User temp folders cleaned"

call :print_step "Cleaning Windows Temp folder..."
del /s /q "C:\Windows\Temp\*.*" >nul 2>&1
call :show_progress
call :print_success "Windows Temp folder cleaned"

call :print_step "Cleaning browser caches..."
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache" (
    rd /s /q "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache" >nul 2>&1
)
if exist "%USERPROFILE%\AppData\Local\Mozilla\Firefox\Profiles" (
    for /d %%x in ("%USERPROFILE%\AppData\Local\Mozilla\Firefox\Profiles\*") do (
        del /s /q "%%x\cache2\*.*" >nul 2>&1
    )
)
if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
)
call :show_progress
call :print_success "Browser caches cleaned"

call :print_step "Cleaning thumbnail cache..."
del /s /q "%USERPROFILE%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
call :show_progress
call :print_success "Thumbnail cache cleaned"
echo.
pause
exit /b 0

:clean_package_cache
call :print_header "TASK: Clean Windows Update Cache"
call :print_step "Stopping Windows Update service..."
net stop wuauserv >nul 2>&1
call :show_progress

call :print_step "Cleaning Windows Update cache..."
del /s /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
call :show_progress

call :print_step "Starting Windows Update service..."
net start wuauserv >nul 2>&1
call :show_progress
call :print_success "Windows Update cache cleaned"

call :print_step "Cleaning Store cache..."
wsreset.exe >nul 2>&1
timeout /t 5 >nul
call :print_success "Store cache cleaned"
echo.
pause
exit /b 0

:clean_system_logs
call :print_header "TASK: Clean System Logs"
call :print_step "Clearing Application logs..."
wevtutil.exe cl Application >nul 2>&1
call :show_progress
call :print_success "Application logs cleared"

call :print_step "Clearing System logs..."
wevtutil.exe cl System >nul 2>&1
call :show_progress
call :print_success "System logs cleared"

call :print_step "Clearing Security logs..."
wevtutil.exe cl Security >nul 2>&1
call :show_progress
call :print_success "Security logs cleared"
echo.
pause
exit /b 0

:clean_misc_files
call :print_header "TASK: Clean Miscellaneous Files"
call :print_step "Emptying Recycle Bin..."
rd /s /q "C:\$Recycle.Bin" >nul 2>&1
call :show_progress
call :print_success "Recycle Bin emptied"

call :print_step "Cleaning Prefetch files..."
del /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
call :show_progress
call :print_success "Prefetch files cleaned"

call :print_step "Cleaning old files from Downloads..."
forfiles /p "%USERPROFILE%\Downloads" /s /m *.* /d -30 /c "cmd /c del @path" >nul 2>&1
call :show_progress
call :print_success "Old files cleaned from Downloads"

call :print_step "Cleaning recent files list..."
del /s /q "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Recent\*.*" >nul 2>&1
call :show_progress
call :print_success "Recent files list cleaned"
echo.
pause
exit /b 0

:check_disk_health
call :print_header "TASK: Disk Health Check"
call :print_step "Checking disk space..."
wmic logicaldisk get caption,freespace,size | findstr "C:"
call :show_progress
call :print_success "Disk space checked"

call :print_step "Running SMART check..."
wmic diskdrive get status | findstr "OK" >nul 2>&1
if %errorLevel% equ 0 (
    call :show_progress
    call :print_success "SMART status: Healthy"
) else (
    call :print_warning "SMART status check inconclusive"
)

call :print_step "Running CHKDSK (read-only)..."
chkdsk C: >nul 2>&1
call :show_progress
call :print_success "CHKDSK scan completed"
echo.
pause
exit /b 0

:check_filesystem
call :print_header "TASK: Filesystem Check"
call :print_step "Checking filesystem integrity..."
fsutil dirty query C: >nul 2>&1
if %errorLevel% equ 0 (
    call :print_success "Filesystem is clean"
) else (
    call :print_warning "Filesystem may need checking"
)
call :show_progress
echo.
pause
exit /b 0

:system_health_check
call :print_header "TASK: System Health Check"
call :print_step "Checking system uptime..."
systeminfo | findstr "System Boot Time"
call :show_progress
call :print_success "Uptime displayed"

call :print_step "Checking memory usage..."
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /value | findstr "="
call :show_progress
call :print_success "Memory usage checked"

call :print_step "Checking for failed services..."
sc query | findstr "STOPPED" | findstr /v "STOPPABLE"
call :show_progress
call :print_success "Service status checked"

call :print_step "Checking CPU load..."
wmic cpu get loadpercentage | findstr /r "[0-9]"
call :show_progress
call :print_success "CPU load checked"
echo.
pause
exit /b 0

:performance_tweaks
call :print_header "TASK: Performance Tweaks"
call :print_step "Disabling unnecessary services..."
sc config Fax start= disabled >nul 2>&1
sc config TabletInputService start= disabled >nul 2>&1
call :show_progress
call :print_success "Unnecessary services disabled"

call :print_step "Clearing pagefile on shutdown..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f >nul 2>&1
call :show_progress
call :print_success "Pagefile cleanup configured"

call :print_step "Optimizing visual effects..."
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
call :show_progress
call :print_success "Visual effects optimized"
echo.
pause
exit /b 0

:generate_report
call :print_header "GENERATING FINAL REPORT"
echo. >> "%LOG_FILE%"
echo === MERLIN'S CLEANUP REPORT === >> "%LOG_FILE%"
echo Date: %DATE% %TIME% >> "%LOG_FILE%"
echo User: %USERNAME% >> "%LOG_FILE%"
echo Computer: %COMPUTERNAME% >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

call :print_step "Disk usage after cleanup..."
echo Disk Usage: >> "%LOG_FILE%"
wmic logicaldisk get caption,freespace,size | findstr "C:" >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

call :print_step "Memory status..."
echo Memory Status: >> "%LOG_FILE%"
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /value | findstr "=" >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

call :print_success "Report saved to %LOG_FILE%"
echo.
pause
exit /b 0

:: ==============================================================================
:: MENU SYSTEM
:: ==============================================================================

:show_menu
cls
echo.
echo ========================================
echo     MERLIN'S QUICK CLEAN UP - MENU
echo ========================================
echo.
echo 1) Clean Temporary Files
echo 2) Clean Windows Update Cache
echo 3) Clean System Logs
echo 4) Clean Miscellaneous Files
echo 5) Check Disk Health
echo 6) Check Check Filesystem
echo 7) System Health Check
echo 8) Apply Performance Tweaks
echo 9) Run Full Tune-Up (All Tasks)
echo 10) Generate Cleanup Report
echo 0) Exit
echo.
set /p choice=Enter your choice: 
exit /b 0

:: ==============================================================================
:: FULL TUNE-UP ORCHESTRATOR
:: ==============================================================================

:run_full_tuneup
call :print_header "FULL TUNE-UP MODE INITIATED"
call :log_message "Full tune-up started"

call :print_step "Starting Full Tune-Up in 3 seconds..."
timeout /t 3 >nul

call :skip_prompt "Clean Temporary Files"
if %errorLevel% equ 1 call :clean_temp_files

call :skip_prompt "Clean Windows Update Cache"
if %errorLevel% equ 1 call :clean_package_cache

call :skip_prompt "Clean System Logs"
if %errorLevel% equ 1 call :clean_system_logs

call :skip_prompt "Clean Miscellaneous Files"
if %errorLevel% equ 1 call :clean_misc_files

call :skip_prompt "Check Disk Health"
if %errorLevel% equ 1 call :check_disk_health

call :skip_prompt "Check Filesystem"
if %errorLevel% equ 1 call :check_filesystem

call :skip_prompt "System Health Check"
if %errorLevel% equ 1 call :system_health_check

call :skip_prompt "Apply Performance Tweaks"
if %errorLevel% equ 1 call :performance_tweaks

call :generate_report
call :print_success "Full tune-up completed!"
call :log_message "Full tune-up finished"
echo.
pause
exit /b 0

:: ==============================================================================
:: MAIN EXECUTION - THIS WAS MISSING!
:: ==============================================================================

:: Show splash screen
call :show_splash

:: Main menu loop
:menu_loop
call :show_menu

if "%choice%"=="1" call :clean_temp_files
if "%choice%"=="2" call :clean_package_cache
if "%choice%"=="3" call :clean_system_logs
if "%choice%"=="4" call :clean_misc_files
if "%choice%"=="5" call :check_disk_health
if "%choice%"=="6" call :check_filesystem
if "%choice%"=="7" call :system_health_check
if "%choice%"=="8" call :performance_tweaks
if "%choice%"=="9" call :run_full_tuneup
if "%choice%"=="10" call :generate_report
if "%choice%"=="0" goto :end_script

echo.
echo [INFO] Press any key to return to menu...
pause >nul
goto :menu_loop

:: Reset colors on exit
:end_script
color 07
echo.
echo [INFO] Thank you for using Merlin's Quick Clean Up!
pause
exit /b 0
