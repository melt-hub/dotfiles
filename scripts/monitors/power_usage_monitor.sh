#!/bin/bash

# paths for status tracking
STATUS_FILE="/tmp/power_usage_status"
RAPL_PATH="/sys/class/powercap/intel-rapl:0"
MY_USER="melt"

# background loop for continuous monitoring
while true; do
    # check power source
    AC_ON=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n 1)
    BAT_P=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)

    if [ "$AC_ON" -eq 1 ] && [ -f "$RAPL_PATH/energy_uj" ]; then
        # plugged: calculate delta from RAPL (requires root)
        E1=$(cat "$RAPL_PATH/energy_uj")
        sleep 1
        E2=$(cat "$RAPL_PATH/energy_uj")
        W=$(echo "scale=4; ($E2 - $E1) / 1000000" | bc -l)
    elif [ -n "$BAT_P" ]; then
        # battery: read instantaneous power
        P_NOW=$(cat "$BAT_P/power_now" 2>/dev/null || echo 0)
        W=$(echo "scale=4; $P_NOW / 1000000" | bc -l)
    fi

    # format output [0.0 W]
    W_FORM=$(printf "%.1f" "${W:-0.0}" 2>/dev/null || echo "0.0")
    echo "[$W_FORM W]" > "$STATUS_FILE"
    
    # fix permissions so waybar user can read it
    chown $MY_USER:$MY_USER "$STATUS_FILE"
    chmod 644 "$STATUS_FILE"
    
    [ "$AC_ON" -ne 1 ] && sleep 1
done