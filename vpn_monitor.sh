#!/bin/bash
# this script watches for a VPN connection that has been active for over an hour
# once a VPN has been connected for an hour, the user is prompts to snooze for
# an hour; if they respond "snooze" they are prompted again in an hour.

SNOOZE_FILE="/tmp/vpnmonitor_snooze"
VPN_START=0
THRESHOLD=3600  # 1 hour in seconds (3600s)
SLEEP=300       # sleep for 5 minutes (300s)

log() {
    local DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "$DATE: $1"
}

prompt() {
    osascript -e 'display dialog "VPN has been on for an hour. Do you want to turn it off or snooze this notification for an hour?" buttons {"Turn Off", "Snooze"} default button "Turn Off"'
}

disconnect_vpn() {
    VPN_SERVICE=$(scutil --nc list | grep "Connected" | awk -F'"' '{print $2}')
    if [ -n "$VPN_SERVICE" ]; then
        log "found connected VPN '$VPN_SERVICE' and attempting to disconnect..."
        scutil --nc stop "$VPN_SERVICE"
    else
        log "no connected VPN found"
    fi
}

remove_snooze() {
    if [ -f "$SNOOZE_FILE" ]; then
        rm "$SNOOZE_FILE"
    fi
}

while true; do
    if scutil --nc list | grep -q "Connected"; then
        if [ $VPN_START -eq 0 ]; then
            VPN_START=$(date +%s)
        else
            CURRENT_TIME=$(date +%s)
            ELAPSED=$((CURRENT_TIME - VPN_START))
            
            if [ $ELAPSED -ge $THRESHOLD ]; then
                if [ -f "$SNOOZE_FILE" ]; then
                    LAST_SNOOZE=$(cat "$SNOOZE_FILE")
                    if [ $((CURRENT_TIME - LAST_SNOOZE)) -lt $THRESHOLD ]; then
                        sleep $((THRESHOLD - SLEEP))    # line 42 will sleep for 5 minutes 
                        continue
                    else
                        remove_snooze
                    fi
                fi
                USER_RESPONSE=$(prompt)
                log "$USER_RESPONSE"
                if [[ "$USER_RESPONSE" == *"Snooze"* ]]; then
                    date +%s > "$SNOOZE_FILE"

                elif [[ "$USER_RESPONSE" == *"Turn Off"* ]]; then
                    disconnect_vpn
                    remove_snooze
                    VPN_START=0
                fi
            fi
        fi
    else
        VPN_START=0
    fi
    sleep $SLEEP
done
