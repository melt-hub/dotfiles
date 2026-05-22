#!/bin/bash

# create a temporary log file to capture error messages
ERROR_LOG=$(mktemp)

# download firmware updates metadata and write:
# + stout: to variable output
# + sterr: to the log file
output=$(fwupdmgr get-updates 2>"$ERROR_LOG")
exit_code=$?

if [ $exit_code -eq 0 ]; then
    # captures the number of updates available by counting how many
    # '·' are in the get-updates output. (each '·' is a new update)
    updates=$(echo "$output" | grep -c "·")
    echo "󰏗 $updates"
elif [ $exit_code -eq 2 ]; then
    echo ""
else
    err_msg=$(cat "$ERROR_LOG")
    notify-send -t 30000 -u critical -r 9994 -i dialog-warning "Firmware Monitor" "$err_msg"
    echo "󰀦 FW"
fi

# cleanup: remove the temporary log file
rm -f "$ERROR_LOG"