### ====================| MELT's BASHRC |====================

## ---------- GLOBAL DEFINITIONS ----------

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

## ---------- ENVIRONMENT & PATH ----------

# add local bins to PATH if they exist
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

#
export GTK_USE_PORTAL=1

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
    notify-send -i audio-headphones "Bluetooth" "Connected to Nothing Earbuds"
}

bt-earbudsb() {
    bluetoothctl connect 84:0F:2A:71:4A:C1 && \
    notify-send -i audio-headphones "Bluetooth" "Connected to Oppo Earbuds"    
}

bt-switchto() {
    bluetoothctl disconnect
    if [ "$1" == "-s" ]; then
        bt-speakers
    elif [ "$1" == "-ea" ]; then
        bt-earbuds
    elif [ "$1" == "-eb" ]; then
        bt-earbudsb
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