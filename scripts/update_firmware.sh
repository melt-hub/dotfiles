#!/bin/bash

ERROR_LOG=$(mktemp)

sudo fwupdmgr refresh && sudo fwuupdmgr update 2>"$ERROR_LOG"
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "" > /tmp/available_firmware_updates
    if [ -f /run/reboot-required ]; then
        notify-send -t 30000 -u critical -r 9994 -i software-update-urgent \
        "Reboot Required" "Firmware updates are ready to be installed"
    fi
else
    ERR_MSG=$(cat "$ERROR_LOG")
    if [ -z "$ERR_MSG" ]; then
        ERR_MSG="Something went wrong while updating firmware."
        ERR_MSG="$ERR_MSG Check hardware connection or LVFS status."
    fi
    notify-send -t 30000 -u critical -r 9994 -i software-update-urgent \
    "Firmware Update Error" "$ERR_MSG"

    echo "󰀦 FWUP" > /tmp/available_firmware_updates
fi

rm -f "$ERROR_LOG"