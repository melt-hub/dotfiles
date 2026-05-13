#!/bin/bash

# 1. capture selected pixel's color
COLOR=$(grim -g "$(slurp -p)" -t ppm - | convert - -format '#%[hex:p{0,0}]' info:-)

# ESC for canceling
if [ -z "$COLOR" ]; then
    exit 0
fi

# 2. create a monochromatic 64x64 pixels image of the captured color
PREVIEW_IMG="/tmp/color_preview.png"
convert -size 32x32 xc:"$COLOR" "$PREVIEW_IMG"

# 3. copy HEX to clipboard
echo -n "$COLOR" | wl-copy

# 4. send notification using generated image as icon
# using -r 9992 to replace previous notification 
notify-send -i "$PREVIEW_IMG" -t 4000 -r 9992 "Color Picker" "Copied: $COLOR"