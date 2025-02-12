#!/bin/bash
# this script watches for a VPN connection that has been active for over an hour
# once a VPN has been connected for an hour, the user is prompts to snooze for
# an hour; if they respond "no" they are prompted again in 5 minutes, otherwise an hour.

SNOOZE_FILE="/tmp/vpnmonitor_snooze"
VPN_START=0
THRESHOLD=3600  # 1 hour in seconds (3600)
SLEEP=300       # sleep for 5 minutes

prompt() {
  osascript -e 'display dialog "VPN has been on for an hour. Do you want to snooze this notification for an hour?" buttons {"Yes", "No"} default button "Yes"'
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
                        sleep $THRESHOLD - $SLEEP    # line 42 will sleep for 5 minutes 
                        continue
                    else
                        rm "$SNOOZE_FILE"
                    fi
                fi
                USER_RESPONSE=$(prompt)
                if [[ "$USER_RESPONSE" == *"Yes"* ]]; then
                    date +%s > "$SNOOZE_FILE"
                fi
            fi
        fi
    else
        VPN_START=0
    fi
    sleep $SLEEP
done
