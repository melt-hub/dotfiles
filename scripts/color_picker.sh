#!/bin/bash

# identifier for dunst to replace existing color picker notifications
NOTIF_ID=9992

# create a unique temporary log file to capture pipeline errors
ERROR_LOG=$(mktemp)

# path for the generated preview icon
PREVIEW_IMG="/tmp/color_preview.png"

# execution block wrapped to capture errors from the complex command pipeline
{
    # color capture pipeline:
    # + slurp -p: selects a single pixel geometry
    # + grim: captures that specific pixel in ppm format (raw pixels)
    # + convert: imagemagick extracts the hex value of the first pixel p{0,0}
    COLOR=$(grim -g "$(slurp -p)" -t ppm - | convert - -format '#%[hex:p{0,0}]' info:-)

    # if the user presses ESC, slurp returns empty
    # exit silently as it's an intentional cancel
    if [ -z "$COLOR" ]; then
        rm -f "$ERROR_LOG"
        exit 0
    fi

    # preview generation:
    # + xc:"$COLOR" creates a canvas of the exact captured color
    # + use a 64x64 size for notification icon
    convert -size 64x64 xc:"$COLOR" "$PREVIEW_IMG"

    # clipboard integration:
    # + copies the hex string to the wayland clipboard without trailing newline
    echo -n "$COLOR" | wl-copy

    # success notification:
    # + the -i flag: uses the freshly generated image as the notification icon
    notify-send -i "$PREVIEW_IMG" -t 4000 -r $NOTIF_ID "Color Picker" "Copied: $COLOR"

} 2>"$ERROR_LOG"
exit_code=$?

# error handling logic for missing dependencies or wayland issues
if [ $exit_code -ne 0 ]; then
    err_msg=$(cat "$ERROR_LOG")
    [ -z "$err_msg" ] && err_msg="Failed to capture color or generate preview"
    
    # send diagnostic notification for software failures
    # (e.g. imagemagick not installed)
    notify-send -u critical -r $NOTIF_ID -i dialog-error "Color picker error" "$err_msg"
fi

# cleanup: remove the temporary log file
rm -f "$ERROR_LOG"