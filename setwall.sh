#!/bin/bash

# Check for provided image path
if [ -z "$1" ]; then
    echo "Add an image: $0"
    exit 1
fi

# Convert to absolute file path
WALLPAPER=$(realpath "$1")

# Check if image exsist
if [ ! -f "$WALLPAPER" ]; then
    echo "File not found: $WALLPAPER"
    exit 1
fi

############################
# Set SDDM Background Image:
############################

# Set to theme and respective path used
THEME_DIR="/usr/share/sddm/themes/Sugar-Candy/Backgrounds"
LOGIN_IMAGE="login_image.jpg"
BACKGROUNDS_PATH="/usr/share/sddm/themes/Sugar-Candy/Backgrounds/$LOGIN_IMAGE"
CONF_FILE="/usr/share/sddm/themes/Sugar-Candy/theme.conf"

if [ -d "$THEME_DIR" ]; then
    sudo cp $WALLPAPER $BACKGROUNDS_PATH
    if [ -f "$CONF_FILE" ]; then
        sed -i 's|^Background="Backgrounds/"|Background="Backgrounds/login_image.jpg"|' $CONF_FILE
        echo "Login Image Changed"
    else
        echo "Configuration File Not Found: $CONF_FILE"
    fi
else 
    echo "Theme Directory Not Found: $THEME_DIR"
fi

######################
# Set Hyprpaper Image:
######################

HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

if [ -f "$HYPRPAPER_CONF" ]; then
    sed -i "s|^preload *= .*|preload = $WALLPAPER|" $HYPRPAPER_CONF
    sed -i "s|^wallpaper = .*|wallpaper = , $WALLPAPER|" $HYPRPAPER_CONF
    
    # Kill and Reload Hyprpaper Instance
    killall hyprpaper 2>/dev/null
    hyprpaper >/dev/null &
    echo "Wallpaper Changed"
else
    echo "Hyprpaper Config Not Found: $HYPRPAPER_CONF" 
fi

#####################
# Set Hyprlock Image:
#####################

HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

if [ -f "$HYPRLOCK_CONF" ]; then
    sed -i "/background {/,/}/s|^[[:space:]]*path = .*|   path = $WALLPAPER|" $HYPRLOCK_CONF
    echo "Lockscreen Changed"
else
    echo "Hyprlock Config Not Found: $HYPRLOCK_CONF"
fi

############
# Finished #
############
