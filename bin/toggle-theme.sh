#!/usr/bin/env bash
cd /home/marco/nixos

if [ -f assets/is-light ]; then
    # Dark mode
    rm assets/is-light
    echo "Switching to Dark Mode..."
else
    # Light mode
    touch assets/is-light
    echo "Switching to Light Mode..."
fi

# Add to git
git add assets/is-light

# Rebuild
sudo nixos-rebuild switch --flake '/home/marco/nixos#amd'

# Reload Caelestia
caelestia scheme set -n dynamic
