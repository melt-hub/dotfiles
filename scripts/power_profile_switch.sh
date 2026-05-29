#!/bin/bash

# toggle between automatic and manual performance mode
MANUAL_FLAG="/tmp/power_manual_mode"

if [ -f "$MANUAL_FLAG" ]; then
    # return to auto mode
    rm "$MANUAL_FLAG"
    notify-send -t 2000 -r 9997 "Power Profile" "Mode: auto"
else
    # force performance mode
    touch "$MANUAL_FLAG"
    powerprofilesctl set performance
    notify-send -t 2000 -r 9997 "Power Profile" "Mode: performance"
fi

# trigger immediate update of the status file
/home/melt/.local/bin/power_profile_switcher.sh