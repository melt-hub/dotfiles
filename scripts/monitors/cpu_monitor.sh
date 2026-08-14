#!/bin/bash

STATUS_FILE="/tmp/cpu_freq_status"
FREQ_PATH="/sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq"

# Calculate average CPU frequency in GHz across active policy cores
VAL=$(awk '{sum+=$1; count++} END {if (count > 0) printf "%.1f", sum/(count*1000000)}' $FREQ_PATH 2>/dev/null)

# Fallback to default output if sysfs is unreadable or empty
if [ -z "$VAL" ]; then
    echo "0.0GHz" > "$STATUS_FILE"
else
    echo "${VAL}GHz" > "$STATUS_FILE"
fi