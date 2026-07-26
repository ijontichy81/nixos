#!/usr/bin/env bash

FLAKE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
IS_LIGHT_FILE="$FLAKE_DIR/assets/is-light"

# 1. Toggle is-light flag for stylix
if [ -f "$IS_LIGHT_FILE" ]; then
    rm "$IS_LIGHT_FILE"
    MODE="dark"
    CURSOR="catppuccin-latte-mauve-cursors"
else
    touch "$IS_LIGHT_FILE"
    MODE="light"
    CURSOR="catppuccin-macchiato-peach-cursors"
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
hyprctl setcursor "$CURSOR" 28 2>/dev/null

# 5. Update Hyprland window borders to match current scheme
if [ "$MODE" = "dark" ]; then
    hyprctl keyword general:col.active_border "rgba(cba6f7ee) rgba(89b4faee) 45deg" 2>/dev/null
    hyprctl keyword general:col.inactive_border "rgba(585b70aa)" 2>/dev/null
else
    hyprctl keyword general:col.active_border "rgba(8839efee) rgba(04a5e5ee) 45deg" 2>/dev/null
    hyprctl keyword general:col.inactive_border "rgba(9ca0b0aa)" 2>/dev/null
fi

# 6. Reload UI components
pkill nautilus
