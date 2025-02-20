# Overview
This project is meant to provide a way to be notified that a VPN connection has been left on for over an hour.

# Installation
Clone the repo, then run `install.sh`. This will create a `launchd` service that runs the monitoring script at startup. 

# Compatibility
This script has only been tested and confirmed to work on macOS Sonoma 14.4.1.

# License
See project LICENSE.

# Features
When installed and a VPN is connected, you will be prompted after one hour of connection time to either snooze
the notification for an hour or turn off the VPN.

Prompt responses and VPN disconnection attempts are logged to /tmp/vpn_monitor.log
