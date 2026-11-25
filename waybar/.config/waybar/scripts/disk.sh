#!/usr/bin/env bash
# Waybar disk module: root (/) usage as JSON with a detailed tooltip.
df -h / | awk 'NR==2 {
  printf "{\"text\":\"%s\",\"tooltip\":\"Disk /: %s used of %s (%s free)\\nClick: yazi\"}\n", $5, $3, $2, $4
}'
