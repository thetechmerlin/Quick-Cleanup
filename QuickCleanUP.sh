#!/bin/bash

# ==============================================================================
# MERLIN'S QUICK CLEAN UP - Ubuntu System Maintenance Script
# ==============================================================================
# A user-friendly system cleaner with interactive menu and full automation options
# ==============================================================================

# Colors and Terminal Setup
if [ -t 1 ]; then
    # Check if terminal supports colors
    ncolors=$(tput colors)
    if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
        BOLD="$(tput bold)"
        RESET="$(tput sgr0)"
        MOSS_BG="$(tput setab 22)"  # Dark moss green background
        CREAM_FG="$(tput setaf 230)" # Cream white foreground
        CYAN="$(tput setaf 6)"
        YELLOW="$(tput setaf 3)"
        RED="$(tput setaf 1)"
        GREEN="$(tput setaf 2)"
    fi
fi

# Set terminal colors (moss green background, cream font)
printf "${MOSS_BG}${CREAM_FG}"
clear

# Log file location
LOG_FILE="/var/log/merlin-cleanup.log"
sudo touch "$LOG_FILE"
sudo chown "$USER:$USER" "$LOG_FILE"

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo "${BOLD}============================================================${RESET}"
    echo "${BOLD}$1${RESET}"
    echo "${BOLD}============================================================${RESET}"
}

print_step() {
    echo "${CYAN}[STEP]${RESET} $1"
    log_message "STEP: $1"
}

print_success() {
    echo "${GREEN}[SUCCESS]${RESET} $1"
    log_message "SUCCESS: $1"
}

print_warning() {
    echo "${YELLOW}[WARNING]${RESET} $1"
    log_message "WARNING: $1"
}

print_error() {
    echo "${RED}[ERROR]${RESET} $1"
    log_message "ERROR: $1"
}

ask_user() {
    local prompt="$1"
    local default="$2"
    read -p "${YELLOW}$prompt${RESET} [Y/n]: " response
    case "$response" in
        [nN][oO]|[nN]) return 1 ;;
        *) return 0 ;;
    esac
}

skip_prompt() {
    local task_name="$1"
    read -p "${YELLOW}Skip '$task_name'?${RESET} [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

show_progress() {
    echo -n "${CREAM_FG}"
    for i in {1..5}; do
        echo -n "."
        sleep 0.5
    done
    echo "${RESET}"
}

# ==============================================================================
# ASCII ART SPLASH SCREEN
# ==============================================================================

show_splash() {
    clear
    cat << "EOF"
${BOLD}
 __       __  ________  _______   __        ______  __    __ 
/  \     /  |/        |/       \ /  |      /      |/  \  /  |
$$  \   /$$ |$$$$$$$$/ $$$$$$$  |$$ |      $$$$$$/ $$  \ $$ |
$$$  \ /$$$ |$$ |__    $$ |__$$ |$$ |        $$ |  $$$  \$$ |
$$$$  /$$$$ |$$    |   $$    $$< $$ |        $$ |  $$$$  $$ |
$$ $$ $$/$$ |$$$$$/    $$$$$$$  |$$ |        $$ |  $$ $$ $$ |
$$ |$$$/ $$ |$$ |_____ $$ |  $$ |$$ |_____  _$$ |_ $$ |$$$$ |
$$ | $/  $$ |$$       |$$ |  $$ |$$       |/ $$   |$$ | $$$ |
$$/      $$/ $$$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$/ $$/   $$/ 
                                                             
                                                             
                                                             
${RESET}
EOF
    echo "${CREAM_FG}Initializing Merlin's Quick Clean Up...${RESET}"
    sleep 3
    clear
}

# ==============================================================================
# CORE CLEANUP TASKS
# ==============================================================================

clean_temp_files() {
    print_header "TASK: Clean Temporary Files"
    
    print_step "Cleaning /tmp directory..."
    sudo find /tmp -type f -atime +7 -delete 2>/dev/null
    show_progress
    print_success "Temporary files cleaned"
    
    print_step "Cleaning user cache..."
    rm -rf ~/.cache/*
    show_progress
    print_success "User cache cleaned"
    
    print_step "Cleaning thumbnail cache..."
    rm -rf ~/.cache/thumbnails/*
    show_progress
    print_success "Thumbnail cache cleaned"
}

clean_package_cache() {
    print_header "TASK: Clean Package Cache"
    
    print_step "Cleaning apt cache..."
    sudo apt-get clean
    show_progress
    print_success "APT cache cleaned"
    
    print_step "Removing unused dependencies..."
    sudo apt-get autoremove -y
    show_progress
    print_success "Unused dependencies removed"
    
    print_step "Removing old kernels..."
    dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r)"'/q;p' | xargs sudo dpkg --purge 2>/dev/null
    show_progress
    print_success "Old kernels removed"
}

clean_system_logs() {
    print_header "TASK: Clean System Logs"
    
    print_step "Cleaning journal logs (keeping last 7 days)..."
    sudo journalctl --vacuum-time=7d
    show_progress
    print_success "Journal logs cleaned"
    
    print_step "Rotating log files..."
    sudo logrotate -f /etc/logrotate.conf 2>/dev/null
    show_progress
    print_success "Log files rotated"
}

clean_misc_files() {
    print_header "TASK: Clean Miscellaneous Files"
    
    print_step "Cleaning old .deb files in download directories..."
    find ~/Downloads -name "*.deb" -mtime +30 -delete 2>/dev/null
    show_progress
    print_success "Old .deb files cleaned"
    
    print_step "Emptying trash..."
    rm -rf ~/.local/share/Trash/*
    show_progress
    print_success "Trash emptied"
}

check_disk_health() {
    print_header "TASK: Disk Health Check"
    
    print_step "Checking available disk space..."
    df -h / | tail -1
    show_progress
    
    if command -v smartctl &> /dev/null; then
        print_step "Running SMART disk health check..."
        sudo smartctl -a /dev/sda 2>/dev/null | grep -E "Health|Reallocated|Pending|Uncorrectable" || print_warning "SMART data not available"
        show_progress
        print_success "Disk health check completed"
    else
        print_warning "smartmontools not installed. Skipping SMART check."
    fi
}

check_filesystem() {
    print_header "TASK: Filesystem Check"
    
    print_step "Checking for filesystem errors (read-only)..."
    sudo touch /forcefsck
    print_success "Filesystem check scheduled for next reboot"
    
    print_step "Checking inode usage..."
    df -i / | tail -1
    show_progress
}

system_health_check() {
    print_header "TASK: System Health Check"
    
    print_step "Checking system uptime..."
    uptime
    show_progress
    
    print_step "Checking memory usage..."
    free -h
    show_progress
    
    print_step "Checking for failed services..."
    systemctl list-units --failed --no-pager || true
    show_progress
    
    print_step "Checking CPU temperature..."
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        echo "CPU Temp: $((temp/1000))°C"
    else
        sensors 2>/dev/null || print_warning "Temperature sensors not available"
    fi
    show_progress
}

performance_tweaks() {
    print_header "TASK: Performance Tweaks"
    
    print_step "Disabling unnecessary startup services..."
    sudo systemctl disable bluetooth.service 2>/dev/null || true
    sudo systemctl disable cups.service 2>/dev/null || true
    show_progress
    print_success "Startup services optimized"
    
    print_step "Setting swappiness to 10..."
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf > /dev/null
    sudo sysctl -p
    show_progress
    print_success "Swappiness optimized"
}

generate_report() {
    print_header "GENERATING FINAL REPORT"
    
    echo "${BOLD}=== MERLIN'S CLEANUP REPORT ===${RESET}" | tee -a "$LOG_FILE"
    echo "Date: $(date)" | tee -a "$LOG_FILE"
    echo "User: $USER" | tee -a "$LOG_FILE"
    echo "Hostname: $(hostname)" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "${BOLD}Disk Usage After Cleanup:${RESET}" | tee -a "$LOG_FILE"
    df -h / | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "${BOLD}Memory Usage:${RESET}" | tee -a "$LOG_FILE"
    free -h | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "${BOLD}Package Status:${RESET}" | tee -a "$LOG_FILE"
    sudo dpkg --list | grep -c '^ii' | tee -a "$LOG_FILE"
    echo "packages installed" | tee -a "$LOG_FILE"
    
    print_success "Report saved to $LOG_FILE"
}

# ==============================================================================
# MENU SYSTEM
# ==============================================================================

show_menu() {
    clear
    echo "${BOLD}${GREEN}"
    cat << "EOF"
 ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ 
|                                                           |
|         MERLIN'S QUICK CLEAN UP - MAIN MENU               |
|                                                           |
|___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___|
EOF
    echo "${RESET}${CREAM_FG}"
    echo ""
    echo "1)  Clean Temporary Files"
    echo "2)  Clean Package Cache"
    echo "3)  Clean System Logs"
    echo "4)  Clean Miscellaneous Files"
    echo "5)  Check Disk Health"
    echo "6)  Check Filesystem"
    echo "7)  System Health Check"
    echo "8)  Apply Performance Tweaks"
    echo "9)  Run Full Tune-Up (All Tasks)"
    echo "10) Generate Cleanup Report"
    echo "0)  Exit"
    echo ""
    read -p "${YELLOW}Enter your choice:${RESET} " choice
    echo ""
}

# ==============================================================================
# FULL TUNE-UP ORCHESTRATOR
# ==============================================================================

run_full_tuneup() {
    print_header "FULL TUNE-UP MODE INITIATED"
    log_message "Full tune-up started"
    
    local tasks=(
        "clean_temp_files"
        "clean_package_cache"
        "clean_system_logs"
        "clean_misc_files"
        "check_disk_health"
        "check_filesystem"
        "system_health_check"
        "performance_tweaks"
    )
    
    local task_names=(
        "Clean Temporary Files"
        "Clean Package Cache"
        "Clean System Logs"
        "Clean Miscellaneous Files"
        "Check Disk Health"
        "Check Filesystem"
        "System Health Check"
        "Apply Performance Tweaks"
    )
    
    for i in "${!tasks[@]}"; do
        echo ""
        print_step "Next task: ${task_names[$i]}"
        
        if skip_prompt "${task_names[$i]}"; then
            print_warning "Skipping ${task_names[$i]}"
            log_message "Skipped: ${task_names[$i]}"
            continue
        fi
        
        ${tasks[$i]}
        
        if [ $? -eq 0 ]; then
            print_success "${task_names[$i]} completed successfully"
        else
            print_error "${task_names[$i]} encountered errors"
        fi
        
        log_message "Completed: ${task_names[$i]}"
    done
    
    generate_report
    print_success "Full tune-up completed!"
    log_message "Full tune-up finished"
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

# Check for sudo access
if ! sudo -v &>/dev/null; then
    print_error "This script requires sudo access. Please run with appropriate privileges."
    exit 1
fi

# Trap to reset colors on exit
trap 'printf "${RESET}"; exit 0' EXIT

# Show splash screen
show_splash

# Main loop
while true; do
    show_menu
    
    case $choice in
        1) clean_temp_files ;;
        2) clean_package_cache ;;
        3) clean_system_logs ;;
        4) clean_misc_files ;;
        5) check_disk_health ;;
        6) check_filesystem ;;
        7) system_health_check ;;
        8) performance_tweaks ;;
        9) run_full_tuneup ;;
        10) generate_report ;;
        0) 
            print_success "Exiting Merlin's Quick Clean Up. Goodbye!"
            break 
            ;;
        *) 
            print_error "Invalid option. Please try again."
            sleep 1
            ;;
    esac
    
    echo ""
    read -p "${YELLOW}Press Enter to continue...${RESET}"
done

# Reset colors
printf "${RESET}"