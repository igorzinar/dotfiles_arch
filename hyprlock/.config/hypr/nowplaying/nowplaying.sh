#!/bin/bash
status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    # Gets Artist - Title and truncates to 30 chars with "..."
    info=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
    echo "$info" | sed -E 's/^(.{30}).+/\1.../' | sed "s/^/󰎈 /"
elif [ "$status" = "Paused" ]; then
    echo "󰏤 Paused"
else
    echo ""
fi