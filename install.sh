#!/bin/bash

# Get the absolute path of the repo
REPO_PATH=$(cd "$(dirname "$0")"; pwd)

# Define the plist content
PLIST_CONTENT=$(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.github.randy.vpnmonitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>$REPO_PATH/vpn_monitor.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/vpn_monitor.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/vpn_monitor.log</string>
</dict>
</plist>
EOF
)

# Write the plist content to the LaunchAgents directory
PLIST=com.github.randy.vpnmonitor.plist
PLIST_PATH=~/Library/LaunchAgents/
echo "$PLIST_CONTENT" > "$PLIST"
cp "$PLIST" "$PLIST_PATH"
rm "$PLIST"

# Load the plist
launchctl load "$PLIST_PATH"

echo "Service installed and loaded successfully."
