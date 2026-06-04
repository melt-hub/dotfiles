#!/bin/bash

# create a unique temporary log file to isolate error messages from the output

# execute dnf check-update:
# + stdout: list of packages is saved to 'output'
# + stderr: connection issues or repo errors is saved to the log file
# + the -q flag: ensures a cleaner output for parsing

# dnf check-update exit codes:
# + 0  : system is up to date
# + 100: updates are available
# + 1  : an error occurred (e.g., network down, mirror unreachable)

# count non-empty lines that don't start with whitespace to get the correct
# package count
# use grep -c '^\S' to count lines starting with a non-space character
# (i.e. the actual packages)

# system is fully updated, return empty string to hide the waybar module

# capture the error message from the log

# if the log is empty but an error occurred, provide a generic hint

# send a critical notification to dunst for immediate diagnosis
# -r 9995: unique ID to avoid notification spam

# display a warning icon on waybar to prompt manual 'sudo dnf upgrade' check

ERROR_LOG=$(mktemp)
OUTPUT=$(dnf check-update -q 2>"$ERROR_LOG")

EXIT_CODE=$?

if [ $EXIT_CODE -eq 100 ]; then

    updates=$(echo "$OUTPUT" | grep -c '^\S')
    echo "󰏗 $UPDATES"

elif [ $EXIT_CODE -eq 0 ]; then
    echo ""
else

    ERR_MSG=$(cat "$ERROR_LOG")
    if [ -z "$ERR_MSG" ]; then
        ERR_MSG="Something went wrong while checking for updates."
        ERR_MSG="$ERR_MSG Check internet connection or DNF repositories"
    fi
    notify-send -t 30000 -u critical -r 9995 -i software-update-urgent \
    "System Update Error" "$ERR_MSG"
    echo "󰀦 SYSCHK"
fi

# cleanup: delete the temporary log file
rm -f "$ERROR_LOG"