#!/bin/bash

# get the kernel version (shorter format)
RESULT=$(uname -r | cut -d '-' -f1)

if [ -z "$RESULT" ]; then
    echo "N/A"
else
    echo "$RESULT"
fi