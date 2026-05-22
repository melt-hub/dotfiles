#!/bin/bash

# identifier for dunst to replace existing speedtest notifications
NOTIF_ID=9993

# path to the official ookla binary to ensure sway finds it without a full login
# shell
SPEEDTEST_BIN="/home/melt/.local/bin/speedtest"

# create a temporary file to buffer error messages (stderr)
ERROR_LOG=$(mktemp)

# send initial notification to provide immediate feedback
notify-send -r $NOTIF_ID -i network-transmit "Speedtest" "Running Ookla's Speedtest..."

# run the test in json format and capture the entire data object into a variable
# --format=json provides a machine-readable output preventing parsing errors
RAW_JSON=$($SPEEDTEST_BIN --accept-license --accept-gdpr --format=json 2>/dev/null)

if [ $? -eq 0 ]; then
    # the bandwidth field in the json is provided in bytes per second
    # multiply by 8 to get bits and divide by 1.000.000 for megabits (mbps)
    # jq -r extracts the raw value, then printf formats the float to 2 decimal
    # digits
    down_raw=$(echo "$RAW_JSON" | jq -r '.download.bandwidth * 8 / 1000000')
    up_raw=$(echo "$RAW_JSON" | jq -r '.upload.bandwidth * 8 / 1000000')
    ping_raw=$(echo "$RAW_JSON" | jq -r '.ping.latency')

    # format numbers for the ui
    DOWN=$(printf "%.2f Mbps" "$down_raw")
    UP=$(printf "%.2f Mbps" "$up_raw")
    PING=$(printf "%.0f ms" "$ping_raw")

    notify-send -r $NOTIF_ID -t 15000 -i network-receive "Speedtest Results" \
        "󰇚 Down: $DOWN\n󰕒 Up: $UP\n󰓅 Ping: $PING"
else
    # failure: read the specific error message from the log file
    err_msg=$(cat "$ERROR_LOG")
    # if the log is empty, fallback to a generic message
    [ -z "$err_msg" ] && err_msg="Unknown connection error."
    # send critical notification with the captured diagnostic information
    notify-send -r $NOTIF_ID -u critical -t 10000 -i network-error "Speedtest Failed" "$err_msg"
fi

# cleanup: remove the temporary log file
rm -f "$ERROR_LOG"