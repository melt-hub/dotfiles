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
    
    # small buffer to allow the file to be closed correctly
    sleep 0.1
    notify-send -t 5000 -i video-display "Recording saved" "File in $REC_DIR"
    exit 0
fi

# capture screen geometry via slurp and force even dimensions
# mobile decoders (WhatsApp) crash with odd widths/heights
RAW_GEOM=$(slurp -f "%x %y %w %h") || exit 1
read X Y W H <<< $RAW_GEOM

# binary math to ensure width and height are even
EVEN_W=$(( W / 2 * 2 ))
EVEN_H=$(( H / 2 * 2 ))
GEOM="$X,$Y ${EVEN_W}x${EVEN_H}"

# create the flag and start recording
touch "$REC_FLAG"

# we use standard flags for maximum stability and mobile compatibility (yuv420p)
# if this still fails, check $REC_DIR/error.log
wf-recorder -g "$GEOM" --pixel-format yuv420p \
-f "$REC_DIR/$(date +%Y%m%d_%H%M%S).mp4" > "$REC_DIR/error.log" 2>&1 &

# signal waybar immediately
pkill -RTMIN+$SIGNAL waybar