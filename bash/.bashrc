
### ====================| MELT's BASHRC |====================

## ---------- GLOBAL DEFINITIONS ----------
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

## ---------- ENVIRONMENT & PATH ----------
# Add local bins to PATH if they exist
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Cargo/Rust environment
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Use systemd pager only when needed
# export SYSTEMD_PAGER=cat

# Source additional snippets from .bashrc.d
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f "$rc" ] && . "$rc"
    done
fi

## ---------- PROMPT & TTY TITLE ----------
# Set terminal window title dynamically (User@Host: ~)
__set_title() {
    echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/#$HOME/~}\007"
}
PROMPT_COMMAND="__set_title${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

## ---------- ALIASES ----------



## ---------- FUNCTIONS ----------

# Dotfiles sync shortcut
function dotpush() {
    local msg="${1:-Update: $(date +'%Y-%m-%d %H:%M')}"
    cd ~/dotfiles && \
    git add . && \
    git commit -m "$msg" && \
    git push origin main && \
    cd -
}

## ---------- FUNCTIONS ----------

# --- Bluetooth Management ---

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

# --- Network Management ---

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

# --- Utility Functions ---

# Dotfiles sync shortcut
function dotpush() {
    local msg="${1:-Update: $(date +'%Y-%m-%d %H:%M')}"
    cd ~/dotfiles || return
    git add .
    git commit -m "$msg"
    git push origin main
    cd - > /dev/null
}

### ====================| END MELT's BASHRC |====================