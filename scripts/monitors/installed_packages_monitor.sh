#!/bin/bash

STATUS_FILE="/tmp/installed_pkgs"

# Detect package managers and query binaries
DNF_CMD=$(command -v dnf5 || command -v dnf)
RPM_CMD=$(command -v rpm)
FLAT_CMD=$(command -v flatpak)

# Count total RPM packages installed on the system
M_RPM=0
if [ -x "$RPM_CMD" ]; then
    M_RPM=$($RPM_CMD -qa --qf "%{name}\n" 2>/dev/null | wc -l)
fi

# Count user-requested RPM packages
N_USER=0
if [ -x "$DNF_CMD" ]; then
    N_USER=$($DNF_CMD repoquery --installed --userinstalled --queryformat '%{name}\n' 2>/dev/null | wc -l)

    # Fallback if DNF5 reason metadata is unpopulated
    if [ "$N_USER" -lt 20 ]; then
        N_USER=$($DNF_CMD repoquery --installed --queryformat '%{name} %{reason}\n' 2>/dev/null | grep -Ei "user|unknown|none" | wc -l)
    fi
fi

# Count installed Flatpak applications
N_FLAT=0
if [ -x "$FLAT_CMD" ]; then
    N_FLAT=$($FLAT_CMD list --app 2>/dev/null | wc -l)
fi

# Compute total counts
N=$(( N_USER + N_FLAT ))
M=$(( M_RPM + N_FLAT ))

# Format and write output for Waybar and systemd
if [ "$M" -eq 0 ]; then
    RESULT="0/0"
else
    RESULT="$N/$M"
fi

echo "$RESULT" | tee "$STATUS_FILE" 2>/dev/null || echo "$RESULT"