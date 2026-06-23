#!/bin/bash

# Execute fwupdmgr directly to preserve native colors and interactive terminal prompts
sudo fwupdmgr refresh && sudo fwupdmgr update
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "" > /tmp/available_firmware_updates
else
    # Since the upgrade runs interactively in kitty, the exact error is already 
    # visible. A generic background warning is sufficient for Dunst and Waybar.
    ERR_MSG="Something went wrong while updating firmware. Please check the terminal output, hardware connections, or LVFS status."

    notify-send -t 30000 -u critical -r 9994 -i software-update-urgent \
    "Firmware Update Error" "$ERR_MSG"

    echo "󰀦 FWUP" > /tmp/available_firmware_updates
fi