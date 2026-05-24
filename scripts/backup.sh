#!/bin/bash

# define the backup drive paths 
MAIN_DRIVE="/mnt/storage"
BACKUP_DRIVE="/mnt/storage_backup"

# defin home backup directories
DEST1="/mnt/storage/backups/home"
DEST2="/mnt/storage_backup/backups/home"

# define files to exlude from the copy
EXCLUDE_FILE="$HOME/dotfiles/scripts/backup_exclude.txt"

# define path to the file storing last backup date
LAST_BACKUP_FILE="$HOME/.config/last_backup"

# this function checks if parent directory exists, then lanches rsync with:
# + -a: archive
# + -v: verbose
# + -h: readable
# + --delete: a file deleted in home gets deleted in backup too
# + --info=progress2: progress bar
home_rsync() {
    local dest=$1
    if [ -d "$(dirname "$dest")" ]; then
        echo "--- home backup to $dest ---"
        rsync -avh --delete --info=progress2 --exclude-from="$EXCLUDE_FILE" "$HOME/" "$dest/"
        # return rsync exitcode
        return $?
    else
        echo "error: destination $dest not found."
        return 1
    fi
}

# lanches 'n' parallel backups 
home_rsync "$DEST1" &
PID1=$! 
home_rsync "$DEST2" &
PID2=$!

# wait for all 'n' processes and capture their exitcodes
wait $PID1
STATUS1=$?
wait $PID2
STATUS2=$?

# home backup check: both must be 0 for a total success
if [ $STATUS1 -eq 0 ] && [ $STATUS2 -eq 0 ]; then
    echo "HOME SUCCESS $(date +%s)" > "$LAST_BACKUP_FILE"
    notify-send -t 15000 -i drive-harddisk "Backup Success" \
    "Home directory is now safe on both drives"
else
    echo "HOME ERROR $(date +%s)" > "$LAST_BACKUP_FILE"
    notify-send -t 15000 -u critical -i dialog-error "Backup Fail" \
    "One or more drives failed to sync. Check the terminal for more info"
fi

# backup rest of the archive by synchronizing the entire root of the drive,
# except from:
# + home directory (already backed up)
# + lost+found/ (system folder created by ext4, usually not accessible)
# + .Trash-1000/ (local trash bin)
if [ -d "$MAIN_DRIVE" ] && [ -d "$BACKUP_DRIVE" ]; then
    echo "--- syncing all other data from $MAIN_DRIVE to $BACKUP_DRIVE ---"
    rsync -avh --delete --info=progress2 \
        --exclude="backups/home/" \
        --exclude="lost+found/" \
        --exclude=".Trash-1000/" \
        "$MAIN_DRIVE/" "$BACKUP_DRIVE/"
    STATUS_MIRROR=$?
else
    echo "error: one of the drives is not mounted. skipping mirror phase."
    STATUS_MIRROR=1
fi

# rest of the archive backup check: both must be 0 for a total success
if [ $STATUS_MIRROR -eq 0 ]; then
    echo "REST SUCCESS $(date +%s)" >> "$LAST_BACKUP_FILE"
    notify-send -t 15000 -i drive-harddisk "Backup Success" \
    "Home and all external data are now redundant"
else
    echo "REST ERROR $(date +%s)" >> "$LAST_BACKUP_FILE"
    notify-send -t 15000 -u critical -i dialog-error "Backup Fail" \
    "One or more drives failed to sync. Check the terminal for more info"
fi