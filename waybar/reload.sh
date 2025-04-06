#!/bin/bash

# Path to File
CONFIG="/home/david/.config/waybar/config"

# Look for changes
inotifywait -m -e modify "CONFIG" | while read; do
    # Reload waybar
    pkill -SIGUSER1 waybar
    echo "waybar reloaded"
done
