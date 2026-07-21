#!/bin/bash
# ====================| STARTUP LOG GENERATOR |====================
# Measures system boot, user login, service order, and expensive units.

LOG_FILE="$HOME/startup.log"

{
    echo "========================================================================"
    echo "SYSTEM STARTUP LOG - $(date +'%Y-%m-%d %H:%M:%S')"
    echo "========================================================================"
    echo ""
    
    # 1. Total boot times (system and user session)
    echo "--- [1] TOTAL STARTUP TIME ---"
    systemd-analyze | head -n 1
    systemd-analyze --user | head -n 1
    echo ""

    # 2. Count of active services
    echo "--- [2] LOADED SERVICES COUNT ---"
    num_sys=$(systemctl list-units --type=service --state=active | \
        grep -c "\.service")
    num_user=$(systemctl --user list-units --type=service --state=active | \
        grep -c "\.service")
    echo "Active System Services: $num_sys"
    echo "Active User Services:   $num_user"
    echo ""

    # 3. Order / Critical Chain of services
    echo "--- [3] USER SESSION CRITICAL CHAIN (ORDER) ---"
    systemd-analyze --user critical-chain | head -n 15
    echo ""

    # 4. Top 10 most expensive system services (Blame)
    echo "--- [4] TOP 10 SYSTEM SERVICES (BLAME) ---"
    systemd-analyze blame | head -n 10
    echo ""

    # 5. Top 10 most expensive user services (Blame)
    echo "--- [5] TOP 10 USER SERVICES (BLAME) ---"
    systemd-analyze --user blame | head -n 10
    echo "========================================================================"
} > "$LOG_FILE"