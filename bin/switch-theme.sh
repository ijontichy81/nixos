#!/usr/bin/env bash
# Usage: ./switch-theme.sh <path-to-wallpaper>

WALLPAPER="$1"

if [ ! -f "$WALLPAPER" ]; then
    echo "Error: File $WALLPAPER not found."
    exit 1
fi

# 1. Copy wallpaper to fixed location (overwrite)
cp "$WALLPAPER" /home/marco/nixos/assets/current-wallpaper.png

# 2. Stage the change
git -C /home/marco/nixos add assets/current-wallpaper.png

# 3. Trigger NixOS Rebuild
echo "Rebuilding system..."
sudo nixos-rebuild switch --flake '/home/marco/nixos#amd'

# 4. Reload Caelestia
echo "Reloading Caelestia theme..."
caelestia scheme set -n dynamic
