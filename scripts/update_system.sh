#!/bin/bash

# Execute dnf upgrade directly.
# This preserves native terminal colors and prevents the "staircase effect" (staggered output)
# that occurs when redirecting standard error through a pipe under sudo.
sudo dnf upgrade --refresh
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "" > /tmp/available_system_updates

    # Check if a reboot is required using Fedora's native needs-restarting tool
    sudo dnf needs-restarting -r >/dev/null 2>&1
    if [ $? -eq 1 ]; then
        notify-send -t 30000 -u critical -r 9995 -i software-update-urgent \
        "Reboot Required" "A new kernel or core library was installed"
    fi
else
    ERR_MSG="Something went wrong while updating system. Please check the terminal output, your internet connection, or DNF repositories."
    
    notify-send -t 30000 -u critical -r 9995 -i software-update-urgent \
    "System Update Error" "$ERR_MSG"
    echo "󰀦 SYSUPD" >  /tmp/available_system_updates
fi