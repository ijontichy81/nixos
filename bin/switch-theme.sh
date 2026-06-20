#!/usr/bin/env bash
# Usage: ./switch-theme.sh <path-to-wallpaper>

WALLPAPER="$1"

if [ ! -f "$WALLPAPER" ]; then
    echo "Error: File $WALLPAPER not found."
    exit 1
fi

# 1. Update the symlink in assets
ln -sf "$WALLPAPER" /home/marco/nixos/assets/current-wallpaper.png

# 2. Add to git so Nix sees it
git -C /home/marco/nixos add assets/current-wallpaper.png

# 3. Trigger NixOS Rebuild
echo "Rebuilding system with new wallpaper..."
sudo nixos-rebuild switch --flake '/home/marco/nixos#amd'

# 4. Reload Caelestia
echo "Reloading Caelestia theme..."
caelestia scheme set -n dynamic
