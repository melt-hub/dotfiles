# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# adding oh-my-posh to PATH
# export PATH=$PATH:/home/fuck/.config/oh-my-posh

# oh-my-posh theme
# eval "$(oh-my-posh init bash)"

## copypasta to set new themes
# eval "$(oh-my-posh init bash --config '')"

# nordtron theme
# eval "$(oh-my-posh init bash --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/nordtron.omp.json')"

# blueish theme
# eval "$(oh-my-posh init bash --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/blueish.omp.json')"

# kushal theme
# eval "$(oh-my-posh init bash --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/kushal.omp.json')"

# powerlevelclassic theme
#eval "$(oh-my-posh init bash --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/powerlevel10k_classic.omp.json')"

# checks if none of the autostart scripts is running in a given windows, if so runs .local/bin/check-autostart-alacritty.sh
# if [ -n "$ALACRITTY_LOG" ]; then
#  ~/.local/bin/check-autostart-alacritty.sh
# fi

# dynamically displays path in terminal window title
# PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/#$HOME/~}\007"'
__set_title() {
  echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/#$HOME/~}\007"
}

# Safely append the title setter to PROMPT_COMMAND
PROMPT_COMMAND="__set_title${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

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

# Dotfiles sync shortcut
function dotpush() {
    local msg="${1:-Update: $(date +'%Y-%m-%d %H:%M')}"
    cd ~/dotfiles && \
    git add . && \
    git commit -m "$msg" && \
    git push origin main && \
    cd -
}
