#!/bin/bash

# --- 🛠️ Icon Variables (Customize these!) ---
WIFI_CONNECTED_ICON=""
# NOTE: This is not a space its a unicode char.
# This is to get the label to not cut of the icon
PADDING_CHAR="⠀"

# --- 🔍 Check Wi-Fi Status ---

# Check if a Wi-Fi device is listed and in the 'connected' state
nmcli -t -f DEVICE,STATE device | grep -E '^wlo1:connected$' > /dev/null

# You can also use a more general check if your device name isn't always 'wlo1':
# nmcli -t -f DEVICE,STATE device | grep -E '^wifi:connected$' > /dev/null


# The exit code ($?) determines the connection status
if [ $? -eq 0 ]; then
    # If successful (exit code 0), a Wi-Fi connection is active.
    echo "$WIFI_CONNECTED_ICON$PADDING_CHAR"
fi
