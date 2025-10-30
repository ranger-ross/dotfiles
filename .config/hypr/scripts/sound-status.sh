#!/bin/bash

# --- 🛠️ Icon Variables (Customize these!) ---
ICON_HIGH=""
# Muted (0% or muted state)
ICON_MUTED=""
# NOTE: This is not a space its a unicode char.
# This is to get the label to not cut of the icon
PADDING_CHAR="⠀"

# Define the audio control to monitor (e.g., 'Master' or 'Headphone')
# Use 'amixer scontrols' to find the correct name for your system.
CONTROL="Master"

# --- 🔍 Get Sound Data ---

# Use amixer to get the status of the specified control
STATUS=$(amixer get "$CONTROL")

# Extract the volume percentage (e.g., [42%]) and remove brackets
VOLUME=$(echo "$STATUS" | grep -oP '\[\d+%\]' | tail -n 1 | tr -d '[]%')

# Check if the control is muted (look for '[off]' in the last line)
MUTE_STATUS=$(echo "$STATUS" | grep -oP '\[(on|off)\]' | tail -n 1)

# --- ⚙️ Determine Icon and Output ---

if [[ "$MUTE_STATUS" == "[off]" ]] || [[ "$VOLUME" -eq 0 ]]; then
    echo "$ICON_MUTED$PADDING_CHAR"
else
    echo "$ICON_HIGH$PADDING_CHAR"
fi
