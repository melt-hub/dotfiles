#!/bin/bash

# define path for the recording flag and video directory
REC_FLAG="/tmp/recording_active"
REC_DIR="$HOME/clips"
mkdir -p "$REC_DIR"

SIGNAL=8

# if the flag exists, we stop the current recording
if [ -f "$REC_FLAG" ]; then
    rm -f "$REC_FLAG"
    pkill -INT wf-recorder
    
    # signal waybar immediately for instant UI feedback
    pkill -RTMIN+$SIGNAL waybar
    
    # small buffer to allow ffmpeg to finish writing the file
    sleep 0.5
    notify-send -t 5000 -i video-display "Recording saved" "File in $REC_DIR"
    exit 0
fi

# capture screen geometry via slurp
GEOM=$(slurp) || exit 1

# create the flag and start recording
touch "$REC_FLAG"
wf-recorder -g "$GEOM" -c libx264 -p pix_fmt=yuv420p \
-f "$REC_DIR/$(date +%Y%m%d_%H%M%S).mp4" &

# signal waybar immediately: no sleep needed with the flag file method
pkill -RTMIN+$SIGNAL waybar