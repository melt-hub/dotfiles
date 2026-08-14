#!/bin/bash

STATUS_FILE="/tmp/fan_speed_status"
THRESHOLD=3800
HWMON_DIR=""

# Locate the dell_smm hwmon directory dynamically
for f in /sys/class/hwmon/hwmon*/name; do
    if [ "$(cat "$f" 2>/dev/null)" = "dell_smm" ]; then
        HWMON_DIR=$(dirname "$f")
        break
    fi
done

# Fallback if hardware monitor interface is unavailable
if [ -z "$HWMON_DIR" ] || [ ! -f "$HWMON_DIR/fan1_input" ]; then
    echo "" > "$STATUS_FILE"
    exit 0
fi

# Read fan inputs safely with fallback defaults
FAN1=$(cat "$HWMON_DIR/fan1_input" 2>/dev/null || echo 0)
FAN2=$(cat "$HWMON_DIR/fan2_input" 2>/dev/null || echo 0)

# Determine maximum speed between dual fans
SPEED=$FAN1
if [ "${FAN2:-0}" -gt "${FAN1:-0}" ]; then
    SPEED=$FAN2
fi

# Write output if threshold is exceeded, otherwise write empty string
if [ "${SPEED:-0}" -ge "$THRESHOLD" ]; then
    echo "${SPEED}RPM" > "$STATUS_FILE"
else
    echo "" > "$STATUS_FILE"
fi