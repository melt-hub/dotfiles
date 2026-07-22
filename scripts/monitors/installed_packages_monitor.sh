#!/bin/bash

# check for dnf5 (the standard in 2026) or dnf fallback
DNF_CMD=$(command -v dnf5 || command -v dnf)
RPM_CMD=$(command -v rpm)
FLAT_CMD=$(command -v flatpak)

# 1. get total rpm packages (system + user)
# still the fastest way to get the total count (M)
M_RPM=$($RPM_CMD -qa --qf "%{name}\n" 2>/dev/null | wc -l)

# 2. get explicitly installed packages (N)
# In DNF5, we must explicitly add '\n' to --queryformat,
# otherwise all packages are output on a single line.
N_USER=$($DNF_CMD repoquery --installed --userinstalled --queryformat '%{name}\n' 2>/dev/null | wc -l)

# 3. handle edge case for fresh DNF5 migrations
# If N is suspiciously low, we count packages with "unknown" or "none" reason.
# We use 'grep -Ei' to ensure case-insensitivity as DNF5 capitalizes reasons (e.g., "User", "None").
if [ "$N_USER" -lt 20 ]; then
    N_USER=$($DNF_CMD repoquery --installed --queryformat '%{name} %{reason}\n' 2>/dev/null | grep -Ei "user|unknown|none" | wc -l)
fi

# 4. get flatpak app count
if [ -x "$FLAT_CMD" ]; then
    # count only apps, skip the runtimes (libraries)
    N_FLAT=$($FLAT_CMD list --app 2>/dev/null | wc -l)
else
    N_FLAT=0
fi

# 5. final calculation
# n = user-requested rpms + flatpaks
# m = total system rpms + flatpaks
N=$(( N_USER + N_FLAT ))
M=$(( M_RPM + N_FLAT ))

# final output for waybar
if [ "$M" -eq 0 ]; then
    echo "0/0"
else
    echo "$N/$M"
fi