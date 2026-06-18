#!/bin/bash

# define device mac addresses for the audio cycle
# logi z207 speakers, nothing ear, and oppo enco buds2
MAC_LOGI="10:94:97:3B:1F:2B"
MAC_NOTHING="2C:BE:EB:77:51:EB"
MAC_OPPO="84:0F:2A:71:4A:C1"

# unique notification id to prevent spam in dunst
NOTIF_ID=9992

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
    # we take the first one detected if multiple devices are active
    CONNECTED=$(bluetoothctl devices Connected | awk '{print $2}' | head -n 1)

    # implement the rotation logic based on the requirements
    # case 1: no device is connected -> connect the logi speakers
    if [ -z "$CONNECTED" ]; then
        bluetoothctl connect "$MAC_LOGI"

    # case 2: speakers are connected -> switch to nothing ear
    elif [ "$CONNECTED" = "$MAC_LOGI" ]; then
        bluetoothctl disconnect "$MAC_LOGI"
        bluetoothctl connect "$MAC_NOTHING"

    # case 3: nothing ear is connected -> switch to oppo buds
    elif [ "$CONNECTED" = "$MAC_NOTHING" ]; then
        bluetoothctl disconnect "$MAC_NOTHING"
        bluetoothctl connect "$MAC_OPPO"

    # case 4: oppo buds are connected -> disconnect everything
    elif [ "$CONNECTED" = "$MAC_OPPO" ]; then
        bluetoothctl disconnect "$MAC_OPPO"

    # case 5: an unknown device is connected -> disconnect it
    else
        bluetoothctl disconnect "$CONNECTED"
    fi

} 2>"$ERROR_LOG"
EXIT_CODE=$?

# handle execution failures and notify the user via dunst
if [ $EXIT_CODE -ne 0 ]; then
    ERR_MSG=$(cat "$ERROR_LOG")
    if [ -z "$ERR_MSG" ]; then
        ERR_MSG="An unknown error occurred during the bluetooth cycle"
    fi
    notify-send -u critical -t 5000 -r $NOTIF_ID "Bluetooth Error" "$ERR_MSG"
fi

# cleanup: delete the temporary log file
rm -f "$ERROR_LOG"