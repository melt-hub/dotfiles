
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

# Bluetooth connection
alias bt-on='bluetoothctl power on'
alias bt-off='bluetoothctl power off'
alias bt-speakers='bluetoothctl connect 10:94:97:3B:1F:2B'
alias bt-earbuds='bluetoothctl connect 2C:BE:EB:77:51:EB'

# Network connection
alias nw-hotspot='nmcli connection up "hotspot"'
alias nw-home='nmcli connection up "home"'
alias nw-home-guest='nmcli connection up "home-guest"'
alias nw-home-2ghz='nmcli connection up "home-2ghz"'
alias nw-uni='nmcli connection up "uni"'

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

### ====================| END MELT's BASHRC |====================
