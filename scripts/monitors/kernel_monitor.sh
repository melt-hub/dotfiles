#!/bin/bash

STATUS_FILE="/tmp/kernel_version"

# Retrieve kernel release and extract base version string
RESULT=$(uname -r 2>/dev/null | cut -d '-' -f1)

# Write result with fallback handling
if [ -z "$RESULT" ]; then
    echo "N/A" > "$STATUS_FILE"
else
    echo "$RESULT" > "$STATUS_FILE"
fi