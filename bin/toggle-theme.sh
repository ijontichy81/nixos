#!/usr/bin/env bash

FLAKE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
IS_LIGHT_FILE="$FLAKE_DIR/assets/is-light"

# 1. Toggle is-light flag for stylix
if [ -f "$IS_LIGHT_FILE" ]; then
    rm "$IS_LIGHT_FILE"
    MODE="dark"
    CURSOR="catppuccin-frappe-sapphire-cursors"
else
    touch "$IS_LIGHT_FILE"
    MODE="light"
    CURSOR="catppuccin-latte-mauve-cursors"
fi

# 2. Set caelestia scheme to match
caelestia scheme set -m "$MODE"

# 3. Update GTK apps
if [ "$MODE" = "dark" ]; then
    sed -i 's/gtk-application-prefer-dark-theme=0/gtk-application-prefer-dark-theme=1/' \
        ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
else
    sed -i 's/gtk-application-prefer-dark-theme=1/gtk-application-prefer-dark-theme=0/' \
        ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
fi

# 4. Switch cursor theme
sed -i "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$CURSOR/" \
    ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini 2>/dev/null
dconf write /org/gnome/desktop/interface/cursor-theme "'$CURSOR'" 2>/dev/null
hyprctl setcursor "$CURSOR" 32 2>/dev/null

# 5. Reload UI components
pkill nautilus
