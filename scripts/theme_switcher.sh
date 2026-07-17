#!/bin/bash

# root directory for the configuration files
DOT_DIR="$HOME/dotfiles"

# unique notification id to prevent spam in dunst
NOTIF_ID=9994

# list of files to swap (active <-> .switch)
FILES=(
    "dunst/dunstrc"
    "kitty/style.conf"
    "rofi/style.rasi"
    "sway/config.d/06-theme.conf"
    "sway/config.d/02-idle.conf"
    "swaylock/config"
    "waybar/style.css"
)

# counter for successfully swapped files
SUCCESS_COUNT=0

for f in "${FILES[@]}"; do
    TARGET="$DOT_DIR/$f"
    BACKUP="$TARGET.switch"
    TMP="$TARGET.tmp"

    if [[ -f "$TARGET" ]] && [[ -f "$BACKUP" ]]; then
        mv "$TARGET" "$TMP"
        mv "$BACKUP" "$TARGET"
        mv "$TMP" "$BACKUP"
        ((SUCCESS_COUNT++))
    else
        echo "[!!] missing file or backup for: $f" >&2
        notify-send -u normal -t 5000 -r $NOTIF_ID "Theme Switcher" \
        "Warning: $f was skipped (missing .switch file)"
    fi
done

if [ "$SUCCESS_COUNT" -gt 0 ]; then
    if swaymsg reload >/dev/null 2>&1; then
        # 1. Restart Dunst
        killall dunst >/dev/null 2>&1
        dunst >/dev/null 2>&1 &

        # 2. Restart Swayidle per caricare il nuovo $lock_cmd
        # Uccidiamo il processo attuale
        killall swayidle >/dev/null 2>&1
        # Lo riavviamo tramite swaymsg così eredita correttamente l'ambiente del WM
        swaymsg "exec swayidle -w \
            timeout 300 '\$lock_cmd' \
            timeout 600 'swaymsg \"output * power off\"' \
            resume 'swaymsg \"output * power on\"' \
            before-sleep '\$lock_cmd'"

        notify-send -u normal -t 3000 -r $NOTIF_ID "Theme Switcher" \
        "Theme and Idle wallpaper updated"
    else
        notify-send -u critical -t 8000 -r $NOTIF_ID "Theme Error" \
        "Files swapped but Sway failed to reload configuration"
    fi
else
    notify-send -u critical -t 8000 -r $NOTIF_ID "Theme Error" \
    "No files were swapped."
fi