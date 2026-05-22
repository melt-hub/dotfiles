#!/bin/bash
updates=$(dnf check-update -q | grep -v '^$' | wc -l)
if [ "$updates" -gt 0 ]; then
    echo "󰏗 $updates"
else
    echo ""
fi