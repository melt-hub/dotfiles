#!/bin/bash

# --- configuration ---
MAIN_DRIVE="/mnt/storage"
BACKUP_DRIVE="/mnt/storage_backup"
DEST_HOME_MAIN="$MAIN_DRIVE/backups/home"
EXCLUDE_FILE="$HOME/dotfiles/scripts/backup_exclude.txt"
LAST_BACKUP_FILE="$HOME/.config/last_backup"

# --- nightfox colors (ansi) ---
C_CYAN='\033[0;36m'
C_NC='\033[0m' 
C_GRAY='\033[0;90m'

# create temporary files for progress tracking
LOG1=$(mktemp)
LOG_MIRROR=$(mktemp)

# cleanup: restore cursor, remove logs and move to row 13 on exit
trap "tput cup 13 0; tput cnorm; rm -f $LOG1 $LOG_MIRROR" EXIT
tput civis # hide cursor

# --- sanity checks ---

# ensure mountpoints are valid
if ! mountpoint -q "$MAIN_DRIVE"; then
    notify-send -t 15000 -u critical "Backup Aborted" "Main drive: $MAIN_DRIVE not mounted"
    exit 1
fi
if ! mountpoint -q "$BACKUP_DRIVE"; then
    notify-send -t 15000 -u critical "Backup Aborted" "Backup drive: $BACKUP_DRIVE not mounted"
    exit 1
fi

# check for write permissions
if [ ! -w "$MAIN_DRIVE" ]; then
    notify-send -t 15000 -u critical "Backup Aborted" \
    "No permission to write on: $MAIN_DRIVE"
    exit 1
fi
if [ ! -w "$BACKUP_DRIVE" ]; then
    notify-send -t 15000 -u critical "Backup Aborted" \
    "No permission to write on: $BACKUP_DRIVE"
    exit 1
fi

# ensure target directory exists
mkdir -p "$DEST_HOME_MAIN"

# --- dashboard logic function ---
# args: start_row, label, log, pid
draw_progress() {
    local start_row=$1
    local label=$2 log=$3 pid=$4

    while ps -p "$pid" > /dev/null; do
        # process log: transform carriage returns to newlines for parsing
        local raw=$(tr '\r' '\n' < "$log")
        # capture last line with percentage
        local stats=$(echo "$raw" | grep -a '%' | tail -n 1 | xargs)
        # capture last line starting with filename (no space at start)
        local file=$(echo "$raw" | grep -aE '^[^[:space:]]' | grep -vaE 'sending|building|---|\./|^$' | tail -n 1)
        
        # smart truncation: keep prefix and end of file if string > 65 chars
        local disp="${file:-...}"
        [ ${#disp} -gt 65 ] && disp="..${disp: -62}"

        # drawing to terminal
        tput cup "$start_row" 0
        echo -ne "${C_CYAN}${label}${C_NC} ${disp}"
        tput el 
        tput cup $((start_row + 1)) 0
        echo -ne "         ${stats:-waiting...}"
        tput el
        
        sleep 0.2
    done
}

# --- phase 1: home directory backup (home -> storage) ---
clear
echo -e "${C_CYAN}=========================| HOME DIRECTORY BACKUP |=========================${C_NC}\n"

# run rsync in background for the dashboard to track it
rsync -avh --delete --info=progress2 --exclude-from="$EXCLUDE_FILE" "$HOME/" "$DEST_HOME_MAIN/" > "$LOG1" 2>&1 &
PID1=$!

# dashboard starts drawing from row 2
draw_progress 2 "$HOME -> $MAIN_DRIVE:" "$LOG1" "$PID1"
wait $PID1; ST1=$?

# flush RAM to physical drive for phase 1
if [ $ST1 -eq 0 ]; then
    tput cup 4 0
    echo -ne "${C_GRAY}flushing home directory data from RAM to $MAIN_DRIVE..${C_NC}"
    sync
    tput el
fi

# log home backup status
if [ $ST1 -eq 0 ]; then
    echo "HOME SUCCESS $(date +%s)" > "$LAST_BACKUP_FILE"
    notify-send -t 15000 -i drive-harddisk "Home Backup Success" \
    "Home directory is backed up"            
else
    echo "HOME ERROR $(date +%s)" > "$LAST_BACKUP_FILE"
    notify-send -t 15000 -u critical -i dialog-error "Home Backup Failed" \
    "Error while backing up home directory"            
fi

# --- phase 2: storage mirroring (storage -> storage_backup) ---
# move cursor to row 7 to leave space for the previous blocks
tput cup 7 0
echo -e "\n${C_CYAN}==============================| ARCHIVE BACKUP |==============================${C_NC}\n"

if [ -d "$MAIN_DRIVE" ] && [ -d "$BACKUP_DRIVE" ]; then
    # sync everything from MAIN to BACKUP (including the fresh home backup)
    rsync -avh --delete --info=progress2 \
        --exclude="lost+found/" --exclude=".Trash-1000/" \
        "$MAIN_DRIVE/" "$BACKUP_DRIVE/" > "$LOG_MIRROR" 2>&1 &
    PIDM=$!
    
    # dashboard starts drawing from row 9
    draw_progress 9 "\n$MAIN_DRIVE -> $BACKUP_DRIVE:" "$LOG_MIRROR" "$PIDM"
    wait $PIDM; ST_M=$?
    
    # final hardware synchronization
    if [ $ST_M -eq 0 ]; then
        tput cup 11 0
        echo -ne "${C_GRAY}flushing $MAIN_DRIVE data from RAM to $BACKUP_DRIVE..${C_NC}"
        sync
        tput el
    fi
else
    ST_M=1
fi

# log archive mirroring status
if [ $ST_M -eq 0 ]; then
    echo "REST SUCCESS $(date +%s)" >> "$LAST_BACKUP_FILE"
    notify-send -t 15000 -i drive-harddisk "Archive Backup Success" \
    "Your whole archive $MAIN_DRIVE is backed up to $BACKUP_DRIVE"
else
    echo "REST ERROR $(date +%s)" >> "$LAST_BACKUP_FILE"
    notify-send -t 15000 -u critical -i dialog-error "Archive Backup Failed" \
    "Error while backing up archive" 
fi

# final summary notification
if [ $ST1 -eq 0 ] && [ $ST_M -eq 0 ]; then
    notify-send -t 15000 -i drive-harddisk "Backup Success" \
    "Both Home directory and the rest of ${MAIN_DRIVE}'s directories are backed up"
fi

tput cnorm # restore cursor visibility
echo -e "\n${C_GRAY}--- backup finished ---${C_NC}"