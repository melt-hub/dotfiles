#!/bin/bash

# path of the file storing the last home backup date
LAST_BACKUP_FILE="$HOME/.config/last_backup"

# update time threshold
THRESHOLD_DAYS=30 

# current date
CURRENT_DATE=$(date +%s)

# check if a backup has ever been done
if [ ! -f "$LAST_BACKUP_FILE" ]; then
    notify-send -t 15000 -u critical "Backup Required" "First backup never performed"
    exit 0
fi

# parse the log file, it should be in the form:
# HOME [STATUS] [TIMESTAMP]
# REST [STATUS] [TIMESTAMP]
while read -r TYPE STATUS TS; do
    if [ "$TYPE" == "HOME" ]; then
        HOME_STATUS=$STATUS
        HOME_TS=$TS
    elif [ "$TYPE" == "REST" ]; then
        REST_STATUS=$STATUS
        REST_TS=$TS
    fi
done < "$LAST_BACKUP_FILE"

# check for backup errors in either stage
if [ "$HOME_STATUS" == "ERROR" ]; then
    notify-send -t 15000 -u critical -r 9996 -i dialog-error "Last Backup Failed" \
    "Errors detected while backing up HOME. Retry now."
    exit 1
fi
if [ "$REST_STATUS" == "ERROR" ]; then
    notify-send -t 15000 -u critical -r 9996 -i dialog-error "Last Backup Failed" \
    "Errors detected while backing up REST. Retry now."
    exit 1
fi

# compute time difference for both stages
DIFF_HOME=$(( (CURRENT_DATE - HOME_TS) / 86400 ))
DIFF_REST=$(( (CURRENT_DATE - REST_TS) / 86400 ))

# if 30 or more days passed, notify the user
if [ "$DIFF_HOME" -ge "$THRESHOLD_DAYS" ]; then
    notify-send -t 15000 -u critical -r 9996 -i drive-harddisk "Backup Reminder" \
    "HOME backup is $DIFF_HOME days old."
fi
if [ "$DIFF_REST" -ge "$THRESHOLD_DAYS" ]; then
    notify-send -t 15000 -u critical -r 9996 -i drive-harddisk "Backup Reminder" \
    "REST backup is $DIFF_REST days old."
fi