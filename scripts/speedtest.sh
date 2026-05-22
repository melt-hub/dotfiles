#!/bin/bash

# Notification ID for replacement
NOTIF_ID=9993
# Absolute path to the binary
SPEEDTEST_BIN="/home/melt/.local/bin/speedtest"

# 1. Initial notification
notify-send -r $NOTIF_ID -i network-transmit "Speedtest" "Running Official Ookla Speedtest..."

# 2. Run the test with default format (human-readable)
# We capture everything into a variable
RESULTS=$($SPEEDTEST_BIN --accept-license --accept-gdpr 2>&1)
STATUS=$?

if [ $STATUS -eq 0 ]; then
    # 3. Extraction logic using AWK
    # We look for lines starting with Latency, Download, and Upload
    # Example line: "Download: 938.41 Mbps (data used: 1.1 GB)"
    DOWN=$(echo "$RESULTS" | awk -F': ' '/Download:/ {print $2}' | awk '{print $1 " " $2}')
    UP=$(echo "$RESULTS" | awk -F': ' '/Upload:/ {print $2}' | awk '{print $1 " " $2}')
    PING=$(echo "$RESULTS" | awk -F': ' '/Latency:/ {print $2}' | awk '{print $1 " " $2}')

    # 4. Final notification (stays for 15 seconds)
    notify-send -r $NOTIF_ID -t 15000 -i network-receive "Speedtest Results" \
        "󰇚 Down: $DOWN\n󰕒 Up: $UP\n󰓅 Ping: $PING"
else
    # 5. If it fails, show the error
    notify-send -r $NOTIF_ID -t 10000 -u critical -i network-error "Speedtest Failed" "$RESULTS"
fi