#!/bin/bash

# identify the primary disk device
DISK=$(lsblk -no NAME,TYPE | grep 'disk' | head -n 1 | awk '{print $1}')

# check if iostat is installed
if ! command -v iostat &> /dev/null; then
    echo "no iostat"
    exit 1
fi

# get diskstats: we take the average of 1 second
# $3 = kB_read/s, $4 = kB_wrtn/s
STATS=$(iostat -dk 1 2 2>/dev/null | grep "$DISK" | tail -n 1)

# handle cases where the disk doesn't return stats
if [ -z "$STATS" ]; then
    echo "R:0.0MB W:0.0MB"
    exit 0
fi

# extraction and conversion (kB to MB)
# we use awk to ensure floating point math even without bc
echo "$STATS" | awk '{printf "R:%.1fMB W:%.1fMB", $3/1024, $4/1024}'