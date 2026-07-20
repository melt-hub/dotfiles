#!/bin/bash

# read the available entropy from the kernel
RESULT=$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null)

if [ -z "$RESULT" ]; then
    echo "0"
else
    echo "$RESULT"
fi