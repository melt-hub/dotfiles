#!/bin/bash
# ====================| FWUPDMGR UPDATE RUNNER |====================
# Installs staged firmware updates without forcing an immediate reboot.

STATUS_FILE="/tmp/available_firmware_updates"

# Update metadata and stage firmware updates without immediate reboot
sudo fwupdmgr refresh && sudo fwupdmgr update -y --no-reboot-check
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    # Clear Waybar status and close Dunst notification 9994 instantly
    echo "" > "$STATUS_FILE"
    dunstify -C 9994 2>/dev/null
else
    ERR_MSG="Firmware update failed. Please check the terminal output."
    notify-send -t 30000 -u critical -r 9994 -i software-update-urgent \
        "Firmware Update Error" "$ERR_MSG"
    echo "󰀦 FWUP" > "$STATUS_FILE"
fi