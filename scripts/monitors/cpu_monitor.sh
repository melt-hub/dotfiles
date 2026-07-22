#!/bin/bash

# path for cpu frequency scaling
FREQ_PATH="/sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq"

# calculate the average GHz across all cores
# scaling_cur_freq is in KHz, so we divide by 1.000.000
VAL=$(awk '{sum+=$1; count++} END {if (count > 0) printf "%.1f", sum/(count*1000000)}' $FREQ_PATH 2>/dev/null)

# fallback if sysfs is not accessible
if [ -z "$VAL" ]; then
    echo "0.0GHz"
else
    echo "${VAL}GHz"
fi