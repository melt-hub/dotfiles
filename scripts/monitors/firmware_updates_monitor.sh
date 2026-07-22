#!/bin/bash
# ====================| FWUPDMGR CHECK UPDATES |====================
# Checks for firmware updates and writes the result directly to /tmp.

ERROR_LOG=$(mktemp)
STATUS_FILE="/tmp/available_firmware_updates"

# Run get-updates in JSON format for reliable parsing
OUTPUT=$(fwupdmgr get-updates --json 2>"$ERROR_LOG")
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    # Parse JSON and count devices with available updates
    updates=$(echo "$OUTPUT" | jq '.Devices | length' 2>/dev/null)
    
    # Fallback to character counting if jq is missing or fails
    if [ $? -ne 0 ] || [ -z "$updates" ]; then
        updates=$(fwupdmgr get-updates 2>/dev/null | grep -c "·")
    fi
    
    # If updates are greater than 0, show the count. Otherwise, hide.
    if [ -n "$updates" ] && [ "$updates" -gt 0 ]; then
        echo "󰚰 $updates" > "$STATUS_FILE"
    else
        echo "" > "$STATUS_FILE"
    fi
elif [ $EXIT_CODE -eq 2 ]; then
    # System is up to date, empty the status file
    echo "" > "$STATUS_FILE"
else
    # Handle actual execution failures (e.g. offline, service dead)
    ERR_MSG=$(cat "$ERROR_LOG")
    if [ -z "$ERR_MSG" ]; then
        ERR_MSG="Something went wrong while checking for updates."
    fi
    notify-send -t 30000 -u critical -r 9994 -i dialog-warning \
        "Firmware Update Error" "$ERR_MSG"
    echo "󰀦 FWUP" > "$STATUS_FILE"
fi

rm -f "$ERROR_LOG"