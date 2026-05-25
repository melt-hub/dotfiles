#!/bin/bash

# --- configuration ---
MAIN_DRIVE="/mnt/storage"
BACKUP_DRIVE="/mnt/storage_backup"
DEST1="$MAIN_DRIVE/backups/home"
DEST2="$BACKUP_DRIVE/backups/home"
EXCLUDE_FILE="$HOME/dotfiles/scripts/backup_exclude.txt"
LAST_BACKUP_FILE="$HOME/.config/last_backup"

# --- nightfox colors (ansi) ---
C_CYAN='\033[0;36m'
C_NC='\033[0m' 
C_GRAY='\033[0;90m'

LOG1=$(mktemp)
LOG2=$(mktemp)
LOG_MIRROR=$(mktemp)

# cleanup: restore cursor, remove logs and move to row 13 on exit
trap "tput cup 13 0; tput cnorm; rm -f $LOG1 $LOG2 $LOG_MIRROR" EXIT
# hide cursor
tput civis 

# --- sanity checks ---

# check if mountpoints are valid
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

# ensure target directories exist
mkdir -p "$DEST1" "$DEST2"

# --- dashboard logic function ---
draw_progress() {
    local start_row=$1
    local pref1=$2 log1=$3 pid1=$4
    local pref2=$5 log2=$6 pid2=$7

    while ps -p "$pid1" > /dev/null || { [ -n "$pid2" ] && ps -p "$pid2" > /dev/null; }; do
        
        # --- disk 1 processing ---
        local raw1=$(tr '\r' '\n' < "$log1")
        local stats1=$(echo "$raw1" | grep -a '%' | tail -n 1 | xargs)
        local file1=$(echo "$raw1" | grep -aE '^[^[:space:]]' | grep -vaE 'sending|building|---|\./|^$' | tail -n 1)
        
        local path1="${pref1}/${file1:-...}"
        [ ${#path1} -gt 65 ] && path1="${pref1}/..${path1: -55}"

        tput cup "$start_row" 0
        echo -ne "${C_CYAN}${pref1}:${C_NC} ${path1}"
        tput el 
        tput cup $((start_row + 1)) 0
        echo -ne "         ${stats1:-waiting...}"
        tput el

        # --- disk 2 processing (if applicable) ---
        if [ -n "$pid2" ]; then
            local raw2=$(tr '\r' '\n' < "$log2")
            local stats2=$(echo "$raw2" | grep -a '%' | tail -n 1 | xargs)
            local file2=$(echo "$raw2" | grep -aE '^[^[:space:]]' | grep -vaE 'sending|building|---|\./|^$' | tail -n 1)

            local path2="${pref2}/${file2:-...}"
            [ ${#path2} -gt 65 ] && path2="${pref2}/..${path2: -55}"

            tput cup $((start_row + 2)) 0
            echo -ne "${C_CYAN}${pref2}:${C_NC} ${path2}"
            tput el
            tput cup $((start_row + 3)) 0
            echo -ne "         ${stats2:-waiting...}"
            tput el
        fi
        sleep 0.2
    done
}

# --- phase 1: parallel home backup ---
clear
echo -e "${C_CYAN}=== home directory backup ===${C_NC}\n"

rsync -avh --delete --info=progress2 --exclude-from="$EXCLUDE_FILE" "$HOME/" "$DEST1/" > "$LOG1" 2>&1 &
PID1=$!
rsync -avh --delete --info=progress2 --exclude-from="$EXCLUDE_FILE" "$HOME/" "$DEST2/" > "$LOG2" 2>&1 &
PID2=$!

draw_progress 2 "storage" "$LOG1" "$PID1" "storage_backup" "$LOG2" "$PID2"

wait $PID1; ST1=$?
wait $PID2; ST2=$?

# log home backup status
if [ $ST1 -eq 0 ] && [ $ST2 -eq 0 ]; then
    echo "HOME SUCCESS $(date +%s)" > "$LAST_BACKUP_FILE"
    notify-send -t 15000 -i drive-harddisk "Home Backup Success" \
    "Home directory is backed up"            
else
    echo "HOME ERROR $(date +%s)" > "$LAST_BACKUP_FILE"
    notify-send -t 15000 -u critical -i dialog-error "Home Backup Failed" \
    "Error while backing up home directory"            
fi

# --- phase 2: rest of storage backup ---
tput cup 7 0
echo -e "\n${C_CYAN}=== rest of storage backup ===${C_NC}\n"

if [ -d "$MAIN_DRIVE" ] && [ -d "$BACKUP_DRIVE" ]; then
    rsync -avh --delete --info=progress2 \
        --exclude="backups/home/" --exclude="lost+found/" --exclude=".Trash-1000/" \
        "$MAIN_DRIVE/" "$BACKUP_DRIVE/" > "$LOG_MIRROR" 2>&1 &
    PIDM=$!
    
    draw_progress 9 "mirroring" "$LOG_MIRROR" "$PIDM"
    wait $PIDM; ST_M=$?
else
    ST_M=1
fi

# log archive backup status
if [ $ST_M -eq 0 ]; then
    echo "REST SUCCESS $(date +%s)" >> "$LAST_BACKUP_FILE"
    notify-send -t 15000 -i drive-harddisk "Rest Backup Success" \
    "Rest of the directories are backed up"
else
    echo "REST ERROR $(date +%s)" >> "$LAST_BACKUP_FILE"
    notify-send -t 15000 -u critical -i dialog-error "Rest Backup failed" \
    "Error while backing up rest of $MAIN_DRIVE 's directories."
fi

# final notification (Fixed syntax [ ... ] and notify-send)
if [ $ST1 -eq 0 ] && [ $ST2 -eq 0 ] && [ $ST_M -eq 0 ]; then
    notify-send -t 15000 -i drive-harddisk "Backup Success" \
    "Both Home and Archive are now fully redundant."
fi

tput cnorm
echo -e "\n${C_GRAY}--- backup finished ---${C_NC}"