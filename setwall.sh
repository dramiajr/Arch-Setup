#!/bin/bash

# Check for provided image path
if [ -z "$1" ]; then
    echo "Add an image: $0"
    exit 1
fi

WALLPAPER=$(realpath "$1")

# Check if image exsist
if [ ! -f "$WALLPAPER" ]; then
    echo "File not found: $WALLPAPER"
    exit 1
fi

######################
# Set SDDM Background:
######################

# Setting proper theme and respective paths
SDDM_THEME="Sugar-Candy"
THEME_DIR="/usr/share/sddm/themes/$SDDM_THEME/Backgounds"
LOGIN_IMAGE="login_image.jpg"
BACKGROUNDS_PATH="$THEME_DIR/$LOGIN_IMAGE"
CONF_FILE="/usr/share/sddm/themes/$SDDM_THEME/theme.conf"

if [ -d "$THEME_DIR" ]; then
    sudo cp "$WALLPAPER" "$BACKGROUNDS_PATH"
    if [ -f "CONF_FILE" ]; then
        sed -i "s|^Backgrounds= .*|Background=$BACKGROUNDS_PATH|" "CONF_FILE"
        echo "Login Image Changed"
    else
        echo "File not found at $CONF_FILE"
    fi
else
    echo "SDDM theme directory not found: "$THEME_DIR"
fi

######################
# Set Hyprpaper Image:
######################

HYPRPAPER_CONF="~/.config/hypr/hyprpaper.conf"

if [ -f "$HYPRPAPER_CONF" ]; then
    sed -i "s|^preload = .*|preload = $WALLPAPER|" "HYPRPAPER_CONF"
    sed	-i "s|^wallpaper = .*|wallpaper = , $WALLPAPER|" "HYPRPAPER_CONF"
    killall hyprpaper 2>/dev/null
    hyprpaper &
    echo "Wallpaper Changed"
else
    echo "Hyprpaper config not found at $HYPRPAPER_CONF"
fi

#####################
# Set Hyprlock Image:
#####################

HYPRLOCK_CONF="~/.config/hypr/hyprlock.conf"

if [ -f "$HYPRLOCK_CONF" ]; then
    sed -i "s|^path = .*|path = $WALLPAPER|" "HYPRLOCK_CONF"
    echo "Hyprlock Image Changed"
else
    echo "Hyprlock config not found at $HYPRLOCK_CONF"
fi

###########
# THE END #
###########
