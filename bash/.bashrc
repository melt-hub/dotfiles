### ====================| MELT's BASHRC |====================

## ---------- GLOBAL DEFINITIONS ----------

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

## ---------- ENVIRONMENT & PATH ----------

# add local bins to PATH if they exist
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# cargo/rust environment
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# use systemd pager only when needed
# export SYSTEMD_PAGER=cat

# source additional snippets from .bashrc.d
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f "$rc" ] && . "$rc"
    done
fi

## ---------- PROMPT & TTY TITLE ----------

# set terminal window title dynamically (User@Host: ~)
__set_title() {
    echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/#$HOME/~}\007"
}
PROMPT_COMMAND="__set_title${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

## ---------- ALIASES ----------

# TODO

## ---------- MY FUNCTIONS ----------

# dotfiles sync shortcut
function dotpush() {
    local msg="${1:-Update: $(date +'%Y-%m-%d %H:%M')}"
    cd ~/dotfiles && \
    git add . && \
    git commit -m "$msg" && \
    git push origin main && \
    cd -
}

# --- bluetooth management ---

bt-on() {
    bluetoothctl power on && \
    notify-send -i bluetooth "Bluetooth" "Powered ON"
}

bt-off() {
    bluetoothctl power off && \
    notify-send -i bluetooth "Bluetooth" "Powered OFF"
}

bt-speakers() {
    bluetoothctl connect 10:94:97:3B:1F:2B && \
    notify-send -i audio-speakers "Bluetooth" "Connected to Speakers"
}

bt-earbuds() {
    bluetoothctl connect 2C:BE:EB:77:51:EB && \
    notify-send -i audio-headphones "Bluetooth" "Connected to Earbuds"
}

bt-switchto() {
    # disconnect current device first
    bluetoothctl disconnect

    # use == for string comparison
    if [ "$1" == "-s" ]; then
        bt-speakers
    elif [ "$1" == "-e" ]; then
        bt-earbuds
    else
        echo "usage: bt-switchto [-s (speakers) | -e (earbuds)]"
    fi
}


# --- network management ---

nw-hotspot() {
    nmcli connection up "hotspot" && \
    notify-send -i network-wireless "Network" "Connected to Hotspot"
}

nw-hotspot-dru() {
    nmcli connection up "hotspot-dru" && \
        notify-send -i network-wireless "Network" "Amorevol connection"
}

nw-home() {
    nmcli connection up "home" && \
    notify-send -i network-wireless "Network" "Connected to Home Wi-Fi"
}

nw-home-guest() {
    nmcli connection up "home-guest" && \
    notify-send -i network-wireless "Network" "Connected to Guest Wi-Fi"
}

nw-home-2ghz() {
    nmcli connection up "home-2ghz" && \
    notify-send -i network-wireless "Network" "Connected to 2.4GHz Wi-Fi"
}

nw-uni() {
    nmcli connection up "uni" && \
    notify-send -i network-wireless "Network" "Connected to UNIMIB"
}

# ----- updates management -----

ud-system() {
    local ERROR_LOG=$(mktemp)
    local EXIT_CODE
    local ERR_MSG

    sudo dnf upgrade --refresh 2>"$ERROR_LOG"
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        echo "" > /tmp/available_system_updates
 
        if [ -f /var/run/reboot-required ] || \
            rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}\n' | \
            tail -n 1 | grep -qv "$(uname -r)"; then

            notify-send -t 30000 -u critical -r 9995 -i software-update-urgent \
            "Reboot Required" "A new kernel or core library was installed"
        fi
   else
        ERR_MSG=$(cat "$ERROR_LOG")
        if [ -z "$ERR_MSG" ]; then
            ERR_MSG="Something went wrong while updating system."
            ERR_MSG="$ERR_MSG Check internet connection or DNF repositories"
        fi
        notify-send -t 30000 -u critical -r 9995 -i software-update-urgent \
        "System Update Error" "$ERR_MSG"
        echo "󰀦 SYSUPD" >  /tmp/available_system_updates
    fi

    rm -f "$error_log"    
}

ud-firmware() {
    local ERROR_LOG=$(mktemp)
    local EXIT_CODE
    local ERR_MSG

    sudo fwupdmgr refresh && sudo fwuupdmgr update 2>"$ERROR_LOG"
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        echo "" > /tmp/available_firmware_updates
        if [ -f /run/reboot-required ]; then
            notify-send -t 30000 -u critical -r 9994 -i software-update-urgent \
            "Reboot Required" "Firmware updates are ready to be installed"
        fi
    else
        ERR_MSG=$(cat "$ERROR_LOG")
        if [ -z "$ERR_MSG" ]; then
            ERR_MSG="Something went wrong while updating firmware."
            ERR_MSG="$ERR_MSG Check hardware connection or LVFS status."
        fi
        notify-send -t 30000 -u critical -r 9994 -i software-update-urgent \
        "Firmware Update Error" "$ERR_MSG"

        echo "󰀦 FWUP" > /tmp/available_firmware_updates
    fi

    rm -f "$ERROR_LOG"
}