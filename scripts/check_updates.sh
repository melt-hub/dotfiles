#!/bin/bash

# create a unique temporary log file to isolate error messages from the output
ERROR_LOG=$(mktemp)

# execute dnf check-update:
# + stdout: list of packages is saved to 'output'
# + stderr: connection issues or repo errors is saved to the log file
# + the -q flag: ensures a cleaner output for parsing
output=$(dnf check-update -q 2>"$ERROR_LOG")

# dnf check-update exit codes:
# + 0  : system is up to date
# + 100: updates are available
# + 1  : an error occurred (e.g., network down, mirror unreachable)
exit_code=$?

if [ $exit_code -eq 100 ]; then
    # count non-empty lines that don't start with whitespace to get the correct
    # package count
    # use grep -c '^\S' to count lines starting with a non-space character
    # (i.e. the actual packages)
    updates=$(echo "$output" | grep -c '^\S')
    echo "󰏗 $updates"
elif [ $exit_code -eq 0 ]; then
    # system is fully updated, return empty string to hide the waybar module
    echo ""
else
    # capture the error message from the log
    err_msg=$(cat "$ERROR_LOG")
    # if the log is empty but an error occurred, provide a generic hint
    [ -z "$err_msg" ] && err_msg="Something went wrong. Check internet connection or DNF repositories"
    
    # send a critical notification to dunst for immediate diagnosis
    # -r 9995: unique ID to avoid notification spam
    notify-send -t 30000 -u critical -r 9995 -i software-update-urgent "System Update Error" "$err_msg"
    
    # display a warning icon on waybar to prompt manual 'sudo dnf upgrade' check
    echo "󰀦 SYS"
fi

# cleanup: delete the temporary log file
rm -f "$ERROR_LOG"