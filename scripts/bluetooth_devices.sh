#!/bin/bash

# define device mac addresses for the audio cycle
# logi z207 speakers, nothing ear, and oppo enco buds2
MAC_LOGI="10:94:97:3B:1F:2B"
MAC_NOTHING="2C:BE:EB:77:51:EB"
MAC_OPPO="84:0F:2A:71:4A:C1"

# unique notification id to prevent spam in dunst
NOTIF_ID=9992

# time limit in seconds for each connection attempt
T_OUT=10

# create a temporary log file to isolate bluetoothctl errors
ERROR_LOG=$(mktemp)

{
    # ensure the bluetooth controller is powered on before proceeding
    # if it is off, attempt to enable it and wait briefly for initialization
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on || exit 1
        sleep 1
    fi

    # identify the currently connected device mac address
    CONNECTED=$(bluetoothctl devices Connected | awk '{print $2}' | head -n 1)

    # implement the rotation logic with timeout and fallback functionality
    # case 1: no device is connected -> try to connect logi speakers
    if [ -z "$CONNECTED" ]; then
        timeout $T_OUT bluetoothctl connect "$MAC_LOGI"

    # case 2: speakers are connected -> try nothing ear, fallback to speakers
    elif [ "$CONNECTED" = "$MAC_LOGI" ]; then
        bluetoothctl disconnect "$MAC_LOGI"
        if ! timeout $T_OUT bluetoothctl connect "$MAC_NOTHING"; then
            bluetoothctl connect "$MAC_LOGI"
        fi

    # case 3: nothing ear connected -> try oppo buds, fallback to nothing
    elif [ "$CONNECTED" = "$MAC_NOTHING" ]; then
        bluetoothctl disconnect "$MAC_NOTHING"
        if ! timeout $T_OUT bluetoothctl connect "$MAC_OPPO"; then
            bluetoothctl connect "$MAC_NOTHING"
        fi

    # case 4: oppo buds are connected -> disconnect and return to idle
    elif [ "$CONNECTED" = "$MAC_OPPO" ]; then
        bluetoothctl disconnect "$MAC_OPPO"

    # case 5: an unknown device is connected -> disconnect it
    else
        bluetoothctl disconnect "$CONNECTED"
    fi

} 2>"$ERROR_LOG"
EXIT_CODE=$?

# handle execution failures and notify the user via dunst
# exit code 124 indicates the timeout command triggered
if [ $EXIT_CODE -ne 0 ] && [ $EXIT_CODE -ne 124 ]; then
    ERR_MSG=$(cat "$ERROR_LOG")
    if [ -z "$ERR_MSG" ]; then
        ERR_MSG="An unknown error occurred during the bluetooth cycle"
    fi
    notify-send -u critical -t 5000 -r $NOTIF_ID "Bluetooth Error" "$ERR_MSG"
fi

# cleanup: delete the temporary log file
rm -f "$ERROR_LOG"