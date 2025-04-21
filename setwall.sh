#!/bin/bash

############################################ IMPORTANT: #########################################################
# 1. Make sure file is executable before trying to run ( chmod +x setwall.sh )
# 2. If you don't have write permission for file add "sudo" to "sed" command or change file ownership to yourself                          
# 3. script is intended to run as "./setwall.sh /PathTo/Image.jpg" or whatever image extension you are using 
##################################################################################################################

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

#######
# Rofi:
#######

# Copy wallpaper image to Rofi Directory
ROFI_DIR="$HOME/.config/rofi"
IMAGE="image.jpg"
UPDATE_ROFI="$HOME/.config/rofi/$IMAGE"

if [ -d $ROFI_DIR ]; then
    sudo cp $WALLPAPER $UPDATE_ROFI
    echo "Rofi Image Updated"
else
    echo "Rofi Directory Not Found: $ROFI_DIR"
fi 

#################
# Applying Pywal:
#################

# Generate color theme
wal -i $WALLPAPER

############################
# Set SDDM Background Image:
############################

# Set to theme and respective path used
THEME_DIR="/usr/share/sddm/themes/Sugar-Candy/Backgrounds"
LOGIN_IMAGE="login_image.jpg"
BACKGROUNDS_PATH="/usr/share/sddm/themes/Sugar-Candy/Backgrounds/$LOGIN_IMAGE"
CONF_FILE="/usr/share/sddm/themes/Sugar-Candy/theme.conf"

# Grab Pywal Colors
MAIN_COLOR=$(sed -n 16p ~/.cache/wal/colors)
BACKGROUND_COLOR=$(sed -n 1p ~/.cache/wal/colors)
ACCENT_COLOR=$(sed -n 6p ~/.cache/wal/colors)

if [ -d "$THEME_DIR" ]; then
    sudo cp $WALLPAPER $BACKGROUNDS_PATH
    if [ -f "$CONF_FILE" ]; then
        sed -i 's|^Background="Backgrounds/"|Background="Backgrounds/login_image.jpg"|' $CONF_FILE
        sed -i "s|^MainColor=.*|MainColor=$MAIN_COLOR|" $CONF_FILE
        sed -i "s|^AccentColor=.*|AccentColor=$ACCENT_COLOR|" $CONF_FILE 
        sed -i "s|^BackgroundColor=.*|BackgroundColor=$BACKGROUND_COLOR|" $CONF_FILE 
        echo "SDDM Updated"
    else
        echo "Configuration File Not Found: $CONF_FILE"
    fi
else 
    echo "Theme Directory Not Found: $THEME_DIR"
fi

##################
# Hyprland Border:
##################

HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"

# Get color from pywal
COLOR1=$(sed -n 6p ~/.cache/wal/colors)

# Convert to rgba format
C1="rgba(${COLOR1:1}ee)"

BORDER="$C1"

if [ -f "$HYPRLAND_CONF" ]; then
    sed -i -E "s|^\s*(col\.active_border\s*=).*|\1 $BORDER|" $HYPRLAND_CONF
    hyprctl reload
    echo "Hyprland Updated"
else
    echo "Hyprland Config Not Found: $HYPRLAND_CONF"
fi

########
# Kitty:
########

# Reload Kitty color scheme
if pgrep -x kitty > /dev/null; then
    # IMPORTANT: Make sure ~/.cache/wal/colors-kitty.conf 
    # is already added to your ~/.config/kitty/kitty.conf
    kitty @ set-colors --all ~/.cache/wal/colors-kitty.conf
    echo "Terminal Colors Updated"
fi

#########
# Waybar:
#########

# Set to respective paths
pkill waybar && hyprctl dispatch exec "waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css" > /dev/null 2>&1
echo "Waybar Reloaded"

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
