#!/bin/bash
# this script uninstalls and reinstall the plist for the vpn_monitor.sh

launchctl unload ~/Library/LaunchAgents/com.github.randy.vpnmonitor.plist
. install.sh
