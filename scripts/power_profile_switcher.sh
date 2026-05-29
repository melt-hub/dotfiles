#!/bin/bash

# paths for status and state tracking
STATUS_FILE="/tmp/power_profile_status"
MANUAL_FLAG="/tmp/power_manual_mode"
LAST_STATE_FILE="/tmp/power_profile_last_state"

# 1. check for manual override
if [ -f "$MANUAL_FLAG" ]; then
    echo "PERFORMANCE" > "$STATUS_FILE"
    # remove last state to force a fresh check when returning to auto mode
    rm -f "$LAST_STATE_FILE"
    exit 0
fi

# 2. automatic logic (AC vs Battery)
# check the first available AC adapter status
AC_ONLINE=$(cat /sys/class/power_supply/AC*/online | head -n 1)

if [ "$AC_ONLINE" -eq 1 ]; then
    TARGET="balanced"
else
    TARGET="power-saver"
fi

# 3. notification logic using a local state file
# we read the last state we successfully set
LAST_STATE=$(cat "$LAST_STATE_FILE" 2>/dev/null)

if [ "$TARGET" != "$LAST_STATE" ]; then
    # apply the profile and update the state file
    powerprofilesctl set "$TARGET"
    echo "$TARGET" > "$LAST_STATE_FILE"
    # send notification only when the state actually changes
    notify-send -t 2000 -r 9997 "Power Profile" "Mode: $TARGET"
fi

# update the bar status file for waybar
echo "${TARGET^^}" > "$STATUS_FILE"