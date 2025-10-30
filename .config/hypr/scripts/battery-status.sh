#!/bin/bash

# --- 🛠️ Icon Variables (Customize these!) ---
# Full: 100-91%
ICON_FULL="󰁹"
# Three Quarters: 90-66%
ICON_HIGH="󰂀"
# Half: 65-36%
ICON_MEDIUM="󰁾"
# Quarter: 35-11%
ICON_LOW="󰁼"
# Empty/Critical: 10-0%
ICON_EMPTY="󰁺"
# Charging icon
ICON_CHARGING="󰂄"

# --- 🔍 Get Battery Data ---

# Find the device path for the first detected battery (e.g., /org/freedesktop/UPower/devices/battery_BAT0)
BATTERY_PATH=$(upower -e | grep 'battery' | head -n 1)

# Check if a battery device was found
if [ -z "$BATTERY_PATH" ]; then
    echo "No battery found."
    exit 1
fi

# Get the relevant data from upower
BATTERY_INFO=$(upower -i "$BATTERY_PATH")

# Extract the percentage (integer value)
PERCENTAGE=$(echo "$BATTERY_INFO" | grep 'percentage' | awk '{print int($2)}')

# Extract the state (e.g., 'charging', 'discharging', 'fully-charged')
STATE=$(echo "$BATTERY_INFO" | grep 'state' | awk '{print $2}')

# --- ⚙️ Determine Icon and Output ---

# Check if the battery is charging or fully charged
if [[ "$STATE" == "charging" ]] || [[ "$STATE" == "fully-charged" ]]; then
    # Display the charging icon and the percentage
    echo "$ICON_CHARGING $PERCENTAGE%"
else
    # Battery is discharging or unknown state, select icon based on percentage
    if (( PERCENTAGE > 90 )); then
        CURRENT_ICON="$ICON_FULL"
    elif (( PERCENTAGE > 65 )); then
        CURRENT_ICON="$ICON_HIGH"
    elif (( PERCENTAGE > 35 )); then
        CURRENT_ICON="$ICON_MEDIUM"
    elif (( PERCENTAGE > 10 )); then
        CURRENT_ICON="$ICON_LOW"
    else
        CURRENT_ICON="$ICON_EMPTY"
    fi

    # Display the determined icon and percentage
    echo "$CURRENT_ICON $PERCENTAGE%"
fi
