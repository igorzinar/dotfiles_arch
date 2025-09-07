#!/bin/bash

# Define your monitor names
INTERNAL_MONITOR="eDP-1"
EXTERNAL_MONITOR="HDMI-A-1"

# Check for external monitor connection and its state (on/off)
if hyprctl monitors | grep -q "$EXTERNAL_MONITOR"; then
    LID_STATE=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $2}')

    if [ "$LID_STATE" = "closed" ]; then
        # Lid is closed, disable the internal display
        hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
    elif [ "$LID_STATE" = "open" ]; then
        # Lid is open, enable the internal display and arrange them
        # The internal monitor (eDP-1) at 2560x0 (to the right of the external)
        hyprctl keyword monitor "$INTERNAL_MONITOR, 2560x1600@165.00400, 2560x0, 1.07"
        # The external monitor (HDMI-A-1) at 0x0
        hyprctl keyword monitor "$EXTERNAL_MONITOR, 2560x1440@59.95100, 0x0, 1.00"
    fi
else
    # No external monitor connected, ensure the laptop screen is enabled
    hyprctl keyword monitor "$INTERNAL_MONITOR, 2560x1600@165.00400, 0x0, 1.07"
fi
