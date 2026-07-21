#!/bin/bash
# ====================| WAYBAR FAN CHECKER |====================
# Reads Dell SMM fan speed dynamically and hides it if below threshold.

# Threshold in RPM below which the module is hidden (off or silent)
THRESHOLD=3800

# Locate the dell_smm hwmon directory dynamically to prevent reboot swaps
HWMON_DIR=""
for f in /sys/class/hwmon/hwmon*/name; do
    if [ "$(cat "$f" 2>/dev/null)" = "dell_smm" ]; then
        HWMON_DIR=$(dirname "$f")
        break
    fi
done

# Fallback if dell_smm is not found
if [ -z "$HWMON_DIR" ] || [ ! -f "$HWMON_DIR/fan1_input" ]; then
    exit 0
fi

# Read fan speeds (supports dual fans if present, taking the max)
FAN1=$(cat "$HWMON_DIR/fan1_input" 2>/dev/null || echo 0)
FAN2=$(cat "$HWMON_DIR/fan2_input" 2>/dev/null || echo 0)

# Use the highest speed among the two fans
if [ "$FAN2" -gt "$FAN1" ]; then
    SPEED=$FAN2
else
    SPEED=$FAN1
fi

# Output only if it exceeds the threshold, otherwise let Waybar hide it
if [ "$SPEED" -ge "$THRESHOLD" ]; then
    echo "${SPEED}RPM"
fi