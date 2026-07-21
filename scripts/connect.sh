#!/bin/bash
# ====================| ROFI CONNECT MENU |====================
# Shuts down/connects bt and wifi using custom bashrc functions.
# Fully text-only, highly robust, with error handling.

# Dunst notification ID to prevent spamming
NOTIF_ID=9992

# Helper function to display connection errors
notify_error() {
    local device="$1"
    notify-send -u critical -t 5000 -r $NOTIF_ID \
        "Connection Failed" \
        "Could not connect to $device. Is it active?"
}

# Define menu options (pure lowercase text, zero icons)
options="speakers\nearbuds (nothing)\nearbuds (oppo)\nbluetooth off\nbluetooth on\nwifi (home)\nwifi (home guest)\nwifi (home 2ghz)\nwifi (hotspot)\nwifi (hotspot dru)\nwifi (uni)"

# Spawn Rofi dmenu with lowercase prompt
chosen=$(echo -e "$options" | rofi -dmenu -i -p "connect:")

# Handle the escape/cancel case (empty selection)
if [ -z "$chosen" ]; then
    exit 0
fi

# Execute corresponding bashrc function.
# We use backslash-escaped spaces to keep wildcard expansion (*) active.
case "$chosen" in
    *nothing*)
        bash -c "PS1=1 . ~/.bashrc && bt-earbuds" || \
            notify_error "Nothing Earbuds"
        ;;
    *oppo*)
        bash -c "PS1=1 . ~/.bashrc && bt-earbudsb" || \
            notify_error "Oppo Enco Buds 2"
        ;;
    *speakers*)
        bash -c "PS1=1 . ~/.bashrc && bt-speakers" || \
            notify_error "Logi Speakers"
        ;;
    *bluetooth\ off*)
        bash -c "PS1=1 . ~/.bashrc && bt-off" || \
            notify-send -u critical "Bluetooth Error" "Failed to power off"
        ;;
    *bluetooth\ on*)
        bash -c "PS1=1 . ~/.bashrc && bt-on" || \
            notify-send -u critical "Bluetooth Error" "Failed to power on"
        ;;
    *home\ guest*)
        bash -c "PS1=1 . ~/.bashrc && nw-home-guest" || \
            notify_error "Guest Wi-Fi"
        ;;
    *home\ 2ghz*)
        bash -c "PS1=1 . ~/.bashrc && nw-home-2ghz" || \
            notify_error "2.4GHz Wi-Fi"
        ;;
    *home*)
        bash -c "PS1=1 . ~/.bashrc && nw-home" || \
            notify_error "Home Wi-Fi"
        ;;
    *hotspot\ dru*)
        bash -c "PS1=1 . ~/.bashrc && nw-hotspot-dru" || \
            notify_error "Amorevol Hotspot"
        ;;
    *hotspot*)
        bash -c "PS1=1 . ~/.bashrc && nw-hotspot" || \
            notify_error "Hotspot"
        ;;
    *uni*)
        bash -c "PS1=1 . ~/.bashrc && nw-uni" || \
            notify_error "UNIMIB Wi-Fi"
        ;;
    *)
        exit 0
        ;;
esac