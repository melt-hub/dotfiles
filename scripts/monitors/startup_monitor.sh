#!/bin/bash
# ====================| STARTUP LOG GENERATOR |====================
# Measures system boot, user login, service order, and expensive units.
# Automatically exports the performance log as an Emacs Org-mode scrap.

LOG_FILE="$HOME/zk/scraps/system_startup.org"
NOTIF_ID=9991

# Ensure destination directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Gather system information
DISTRO=$(awk -F= '/^NAME=/ {print $2}' /etc/os-release | tr -d '"')
WM="Sway"
CREATED_DATE=$(date +'%Y-%m-%d %H:%M')

# Gather performance stats
SYS_ANALYZE=$(systemd-analyze | head -n 1)
USER_ANALYZE=$(systemd-analyze --user | head -n 1)

# Extract summary metrics for notification
SYS_TOTAL=$(echo "$SYS_ANALYZE" | awk -F '=' '{print $2}' | xargs)
USER_TOTAL=$(echo "$USER_ANALYZE" | awk -F 'finished in' '{print $2}' | xargs)
SLOW_SERVICE=$(systemd-analyze --user blame | head -n 1 | xargs)

# Count active services
NUM_SYS=$(systemctl list-units --type=service --state=active | \
    grep -c "\\.service")
NUM_USER=$(systemctl --user list-units --type=service --state=active | \
    grep -c "\\.service")

# Write the final Org-mode file
{
    echo ":PROPERTIES:"
    echo ":ID:       22b33f9c-f006-4554-8942-d380b7d55add"
    echo ":created:  $CREATED_DATE"
    echo ":END:"
    echo "#+title: system-startup"
    echo "#+author: melt"
    echo "#+filetags: :scrap:"
    echo ""
    echo "* $DISTRO $WM system startup"
    echo ""
    echo "** Total startup time"
    echo ""
    echo "  - *System Boot:* $SYS_TOTAL"
    echo "  - *User Session:* $USER_TOTAL"
    echo ""
    echo "** Loaded services count"
    echo ""
    echo "  - *Active System Services:* $NUM_SYS"
    echo "  - *Active User Services:*   $NUM_USER"
    echo ""
    echo "** User session critical chain (order)"
    echo ""
    echo "#+begin_src text"
    systemd-analyze --user critical-chain | head -n 15
    echo "#+end_src"
    echo ""
    echo "** Top 10 system services (blame)"
    echo ""
    echo "#+begin_src text"
    systemd-analyze blame | head -n 10
    echo "#+end_src"
    echo ""
    echo "** Top 10 user services (blame)"
    echo ""
    echo "#+begin_src text"
    systemd-analyze --user blame | head -n 10
    echo "#+end_src"
} > "$LOG_FILE"

# Send desktop notification with salient metrics
NOTIF_BODY=$(printf "Boot: %s\\nSession: %s\\nSlowest: %s" \
    "$SYS_TOTAL" "$USER_TOTAL" "$SLOW_SERVICE")

notify-send -t 10000 -r $NOTIF_ID -i drive-harddisk \
    "System Booted" "$NOTIF_BODY"