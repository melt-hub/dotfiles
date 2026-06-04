#!/bin/bash

ERROR_LOG=$(mktemp)

sudo dnf upgrade --refresh 2>"$ERROR_LOG"
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "" > /tmp/available_system_updates

    if [ -f /var/run/reboot-required ] || \
        rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}\n' | \
        tail -n 1 | grep -qv "$(uname -r)"; then

        notify-send -t 30000 -u critical -r 9995 -i software-update-urgent \
        "Reboot Required" "A new kernel or core library was installed"
    fi
else
    ERR_MSG=$(cat "$ERROR_LOG")
    if [ -z "$ERR_MSG" ]; then
        ERR_MSG="Something went wrong while updating system."
        ERR_MSG="$ERR_MSG Check internet connection or DNF repositories"
    fi
    notify-send -t 30000 -u critical -r 9995 -i software-update-urgent \
    "System Update Error" "$ERR_MSG"
    echo "󰀦 SYSUPD" >  /tmp/available_system_updates
fi

rm -f "$ERROR_LOG"