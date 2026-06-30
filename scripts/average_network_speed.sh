#!/bin/bash

# Identifier for dunst to replace existing speedtest notifications
NOTIF_ID=9994

# Path to the official ookla binary
SPEEDTEST_BIN="/home/melt/.local/bin/speedtest"

# Number of iterations (default to 10, or use the first command line argument)
ITERATIONS=${1:-10}

# Initialize variables for accumulation and counting successful runs
total_down=0
total_up=0
success_count=0

# Send initial notification to provide immediate feedback
notify-send -r $NOTIF_ID -i network-transmit "Speedtest Batch" "Running $ITERATIONS tests to calculate sample mean..."

echo "Starting sampling: $ITERATIONS tests scheduled."

for ((i=1; i<=ITERATIONS; i++)); do
    echo -n "Test $i/$ITERATIONS... "
    
    # Run the test in json format and silence stderr
    RAW_JSON=$($SPEEDTEST_BIN --accept-license --accept-gdpr --format=json 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # Extract bandwidth in bps, convert to Mbps (multiply by 8, divide by 1,000,000)
        down=$(echo "$RAW_JSON" | jq -r '.download.bandwidth * 8 / 1000000')
        up=$(echo "$RAW_JSON" | jq -r '.upload.bandwidth * 8 / 1000000')
        
        # Accumulate sums using 'bc' for floating-point arithmetic
        total_down=$(echo "$total_down + $down" | bc -l)
        total_up=$(echo "$total_up + $up" | bc -l)
        
        ((success_count++))
        printf "OK (Down: %.2f | Up: %.2f)\n" "$down" "$up"
    else
        echo "FAILED"
    fi
done

# Calculate and display final results if at least one test succeeded
if [ $success_count -gt 0 ]; then
    # Calculate sample means
    avg_down=$(echo "$total_down / $success_count" | bc -l)
    avg_up=$(echo "$total_up / $success_count" | bc -l)

    # Format numbers for the UI/Terminal
    FINAL_DOWN=$(printf "%.2f Mbps" "$avg_down")
    FINAL_UP=$(printf "%.2f Mbps" "$avg_up")

    # Terminal summary
    echo "--------------------------------------"
    echo "Sample mean based on $success_count successful tests:"
    echo "Download: $FINAL_DOWN"
    echo "Upload:   $FINAL_UP"
    echo "--------------------------------------"

    # Send final persistent notification with aggregated results
    notify-send -r $NOTIF_ID -t 0 -i network-receive "Sample Mean Results" \
        "󰇚 Avg Down: $FINAL_DOWN\n󰕒 Avg Up: $FINAL_UP\nBased on $success_count measurements."
else
    # Critical notification if no tests were successful
    notify-send -r $NOTIF_ID -u critical "Speedtest Error" "All $ITERATIONS tests failed to connect."
    exit 1
fi