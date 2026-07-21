#!/bin/bash
# ====================| WAYBAR PING CHECKER |====================
# Pings Cloudflare DNS. Outputs empty if offline to let Waybar hide.

# Ping 1.1.1.1 once with a 2-second timeout
PING_OUT=$(ping -c 1 -W 2 1.1.1.1 2>/dev/null)

if [ $? -eq 0 ]; then
    # Extract the average round-trip time
    RTT=$(echo "$PING_OUT" | awk -F '/' '/rtt/ {print $5}')
    
    # Format to integer
    PING_MS=$(printf "%.0f" "$RTT" 2>/dev/null || echo "$RTT")
    
    # Output formatted string with brackets
    echo "$PING_MS"
fi