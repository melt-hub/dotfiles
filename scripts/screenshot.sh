#!/bin/bash

# define the storage path for screenshots
SHOT_DIR="$HOME/pics/screenshots"
mkdir -p "$SHOT_DIR"

# generate a unique filename based on current timestamp
FILE_PATH="$SHOT_DIR/$(date +%Y%m%d_%H%M%S).png"

# capture selected region via slurp and pass geometry to grim
# exit if selection is aborted
GEOM=$(slurp) || exit 1
grim -g "$GEOM" "$FILE_PATH"

# send a temporary notification to dunst for visual confirmation
notify-send -t 3000 -i image-x-generic "Screenshot captured" "Saved to: $SHOT_DIR"