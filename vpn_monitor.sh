#!/bin/bash
# this script watches for a VPN connection that has been active for over an hour

VPN_START=0
THRESHOLD=3600  # 1 hour in seconds
while true; do
    if scutil --nc list | grep -q "Connected"; then
        if [ $VPN_START -eq 0 ]; then
            VPN_START=$(date +%s)
        else
            CURRENT_TIME=$(date +%s)
            ELAPSED=$((CURRENT_TIME - VPN_START))
            
            if [ $ELAPSED -ge $THRESHOLD ]; then
                osascript -e 'display notification "VPN has been connected for over an hour" with title "VPN Alert"'
            fi
        fi
    else
        VPN_START=0
    fi
    sleep 300  # Wait 5 minutes
done