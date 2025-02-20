#!/bin/bash
# this script reloads the plist for the vpn_monitor.sh so updates take effect.

echo "unloading the vpnmonitor plist"
launchctl unload ~/Library/LaunchAgents/com.github.randy.vpnmonitor.plist
echo "loading the vpnmonitor plist"
launchctl load ~/Library/LaunchAgents/com.github.randy.vpnmonitor.plist
