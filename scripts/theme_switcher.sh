#!/bin/bash

# root directory for the configuration files
DOT_DIR="$HOME/dotfiles"

# unique notification id to prevent spam in dunst
NOTIF_ID=9994

# list of files to swap (active <-> .bak)
# paths are relative to the DOT_DIR variable
FILES=(
    "dunst/dunstrc"
    "kitty/styile.conf"
    "rofi/style.rasi"
    "sway/config.d/06-theme.conf"
    "swaylock/config"
    "waybar/style.css"
)

# counter for successfully swapped files
SUCCESS_COUNT=0

# iterate through the defined files to perform the swap
# the logic uses a temporary file to prevent data loss during moves
for f in "${FILES[@]}"; do
    TARGET="$DOT_DIR/$f"
    BACKUP="$TARGET.bak"
    TMP="$TARGET.tmp"

    # check if both the active file and its backup exist
    if [[ -f "$TARGET" ]] && [[ -f "$BACKUP" ]]; then
        mv "$TARGET" "$TMP"
        mv "$BACKUP" "$TARGET"
        mv "$TMP" "$BACKUP"
        ((SUCCESS_COUNT++))
    else
        # log missing files to stderr and send a transient notification
        echo "[!!] missing file or backup for: $f" >&2
        notify-send -u normal -t 5000 -r $NOTIF_ID "Theme Switcher" \
        "Warning: $f was skipped (missing .bak file)"
    fi
done

# trigger a refresh of the desktop environment components
# swaymsg reload handles the wm and waybar if managed via config
if [ "$SUCCESS_COUNT" -gt 0 ]; then
    if swaymsg reload >/dev/null 2>&1; then
        # force dunst to restart to apply the new dunstrc immediately
        # redirection to /dev/null prevents terminal noise
        killall dunst >/dev/null 2>&1
        dunst >/dev/null 2>&1 &

        notify-send -u normal -t 3000 -r $NOTIF_ID "Theme Switcher" \
        "Theme swapped and environment reloaded"
    else
        notify-send -u critical -t 8000 -r $NOTIF_ID "Theme Error" \
        "Files swapped but Sway failed to reload configuration"
    fi
else
    notify-send -u critical -t 8000 -r $NOTIF_ID "Theme Error" \
    "No files were swapped. Check your dotfiles directory."
fi