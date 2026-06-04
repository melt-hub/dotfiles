#!/bin/bash

# create a temporary log file to capture error messages

# download firmware updates metadata and write:
# + stout: to variable output
# + sterr: to the log file

# fwupdmgr get-updates exit codes:
# + 0: updates are available
# + 2: system is up to date
# + 1: an error occurred (e.g., stale metadata, daemon unreachable)

# captures the number of updates available by counting how many
# '·' are in the get-updates output. (each '·' is a new update)

# cleanup: remove the temporary log file

ERROR_LOG=$(mktemp)
OUTPUT=$(fwupdmgr get-updates 2>"$ERROR_LOG")
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    updates=$(echo "$OUTPUT" | grep -c "·")
    echo "󰏗 $updates"
elif [ $EXIT_CODE -eq 2 ]; then
    echo ""
else
    ERR_MSG=$(cat "$ERROR_LOG")
    if [ -z "$ERR_MSG" ]; then
        ERR_MSG="Something went wrong while checking for updates."
        ERR_MSG="$ERR_MSG Check internet connection or firmware repositories"
    fi
    notify-send -t 30000 -u critical -r 9994 -i dialog-warning \
    "Firmware Update Error" "$ERR_MSG"
    echo "󰀦 FWUP"
fi

rm -f "$ERROR_LOG"