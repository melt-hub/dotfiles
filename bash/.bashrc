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

# zettelkasten sync shortcut
function zkpush() {
    local msg="${1:-Update: $(date +'%Y-%m-%d %H:%M')}"
    cd ~/zk && \
    git add . && \
    git commit -m "$msg" && \
    git push origin master && \
    cd -
}