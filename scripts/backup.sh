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
C_BOLD='\033[1m'

# create temporary files for progress tracking
LOG1=$(mktemp)
LOG_MIRROR=$(mktemp)

# cleanup: restore cursor, remove logs and move to row 17 on exit
trap "tput cup 17 0; tput cnorm; rm -f $LOG1 $LOG_MIRROR" EXIT
tput civis # hide cursor

# --- functions ---

# abbreviates directories to initials if path > 80 chars
# only the filename is highlighted in bold
format_path() {
    local p=$1
    [ "$p" = "..." ] && { echo -ne "    ..."; return; }
    
    local dir=$(dirname "$p")
    local base=$(basename "$p")
    
    if [ ${#p} -gt 80 ]; then
        # take first char of each directory name
        local short_dir=$(echo "$dir" | sed 's/\([^/]\)[^/]*/\1/g')
        echo -ne "    ${short_dir}/${C_BOLD}${base}${C_NC}"
    else
        echo -ne "    ${dir}/${C_BOLD}${base}${C_NC}"
    fi
}

# args: start_row, label, log, pid
draw_progress() {
    local start_row=$1
    local label=$2 log=$3 pid=$4

    while ps -p "$pid" > /dev/null; do
        local raw=$(tr '\r' '\n' < "$log")
        local stats=$(echo "$raw" | grep -a '%' | tail -n 1 | xargs)
        local file=$(echo "$raw" | grep -aE '^[^[:space:]]' | grep -vaE 'sending|building|---|\./|^$' | tail -n 1)
        
        # row 1: cyan label
        tput cup "$start_row" 0
        echo -ne "${C_CYAN}${label}${C_NC}"
        tput el 

        # row 2: path with bold filename
        tput cup $((start_row + 1)) 0
        format_path "${file:-...}"
        tput el

        # row 3: indented stats
        tput cup $((start_row + 2)) 0
        echo -ne "    ${stats:-waiting...}"
        tput el
        
        sleep 0.2
    done    
}

# --- phase 1: home directory backup (home -> storage) ---
clear
echo -e "${C_CYAN}==============================| HOME DIRECTORY BACKUP |==============================${C_NC}\n"

# run rsync in background
rsync -avh --delete --info=progress2 --exclude-from="$EXCLUDE_FILE" "$HOME/" "$DEST_HOME_MAIN/" > "$LOG1" 2>&1 &
PID1=$!

# label in cyan as requested
LABEL1="/home/melt -> $MAIN_DRIVE: "
draw_progress 2 "$LABEL1" "$LOG1" "$PID1"
wait $PID1; ST1=$?

# RAM to Drive flush for phase 1
if [ $ST1 -eq 0 ]; then
    tput cup 5 0
    echo -ne "${C_GRAY}..flushing home directory data from RAM to $MAIN_DRIVE..${C_NC}"
    sync
    tput el
fi

# log and notifications for phase 1
if [ $ST1 -eq 0 ]; then
    echo "HOME SUCCESS $(date +%s)" > "$LAST_BACKUP_FILE"
    notify-send -t 15000 -i drive-harddisk "Home Backup Success" "Home directory is backed up"            
else
    echo "HOME ERROR $(date +%s)" > "$LAST_BACKUP_FILE"
    notify-send -t 15000 -u critical "Home Backup Failed" "Error while backing up home directory"            
fi

# --- phase 2: storage mirroring (storage -> storage_backup) ---
tput cup 7 0
echo -e "${C_CYAN}==============================|     ARCHIVE BACKUP    |==============================${C_NC}\n"

if [ -d "$MAIN_DRIVE" ] && [ -d "$BACKUP_DRIVE" ]; then
    rsync -avh --delete --info=progress2 \
        --exclude="lost+found/" --exclude=".Trash-1000/" \
        "$MAIN_DRIVE/" "$BACKUP_DRIVE/" > "$LOG_MIRROR" 2>&1 &
    PIDM=$!
    
    LABEL2="$MAIN_DRIVE -> $BACKUP_DRIVE: "
    draw_progress 9 "$LABEL2" "$LOG_MIRROR" "$PIDM"
    wait $PIDM; ST_M=$?
    
    # final hardware synchronization
    if [ $ST_M -eq 0 ]; then
        tput cup 12 0
        echo -ne "${C_GRAY}..flushing $MAIN_DRIVE data from RAM to $BACKUP_DRIVE..${C_NC}"
        sync
        tput el
    fi
else
    ST_M=1
fi

# log and notifications for phase 2
if [ $ST_M -eq 0 ]; then
    echo "REST SUCCESS $(date +%s)" >> "$LAST_BACKUP_FILE"
    notify-send -t 15000 -i drive-harddisk "Archive Backup Success" "Your whole archive is redundant"
else
    echo "REST ERROR $(date +%s)" >> "$LAST_BACKUP_FILE"
    notify-send -t 15000 -u critical "Archive Backup Failed" "Error while mirroring archive" 
fi

# final summary
if [ $ST1 -eq 0 ] && [ $ST_M -eq 0 ]; then
    notify-send -t 15000 -i drive-harddisk "Backup Success" "Both Home and Archive are now fully redundant"
fi

# bottom border (reduced extra spacing)
tput cup 14 0
echo -e "${C_CYAN}==============================| --------------------- |==============================${C_NC}"

tput cnorm
tput cup 15 0
echo -e "\n${C_GRAY}--- backup finished ---${C_NC}"