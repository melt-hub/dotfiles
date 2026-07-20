#!/bin/bash

# target host (cloudflare dns)
HOST="1.1.1.1"

# ping logic: 1 packet, 1s deadline, 1s timeout
# we extract only the ms part as an integer
RESULT=$(ping -c 1 -w 1 -W 1 "$HOST" 2>/dev/null | grep -oP 'time=\K\S+')

# error handling: if ping fails or host is unreachable
if [ -z "$RESULT" ]; then
    echo "N/A"
else
    # round to the nearest integer for a cleaner look
    echo "${RESULT%.*}ms"
fi