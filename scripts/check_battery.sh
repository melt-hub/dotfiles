#!/bin/bash

# identifier for dunst to replace existing battery notifications
NOTIF_ID=9991

# create a unique temporary log file to capture internal script errors
ERROR_LOG=$(mktemp)

# execution block wrapped to capture any shell errors into the log file
{
    # dynamically find the battery path (handles BAT0, BAT1, etc.)
    # use head -n 1 to pick the first battery detected by the kernel
    BAT_PATH=$(find /sys/class/power_supply/ -name "BAT*" | head -n 1)

    # check if a battery path actually exists
    if [ -z "$BAT_PATH" ]; then
        echo "Error: no battery detected in /sys/class/power_supply/" >&2
        exit 1
    fi

    # read current capacity and charging status from the kernel filesystem
    # capacity is an integer (0-100), status is a string (e.g., "Discharging")
    BATTERY=$(cat "$BAT_PATH/capacity")
    STATUS=$(cat "$BAT_PATH/status")

    THRESHOLD=15

    # check if the battery is below the threshold and not currently charging
    if [ "$BATTERY" -le "$THRESHOLD" ] && [ "$STATUS" = "Discharging" ]; then
        # send a critical alert that stays on screen for 10s
        notify-send -u critical -t 10000 -r $NOTIF_ID "Low battery" "Level: ${BATTERY}%"
    fi

} 2>"$ERROR_LOG"
exit_code=$?

# error handling logic
if [ $exit_code -ne 0 ]; then
    err_msg=$(cat "$ERROR_LOG")
    # provide a fallback if the error log is empty for some reason
    [ -z "$err_msg" ] && err_msg="Failed to read battery statistics"
    
    # send diagnostic notification for system errors
    notify-send -u critical -t 10000 -r $NOTIF_ID -i battery-missing "Battery monitor error" "$err_msg"
fi

# cleanup: delete the temporary log file
rm -f "$ERROR_LOG"