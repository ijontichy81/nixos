{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "Catppuccin Mocha";
      window-padding-x = "8,4";
      window-padding-y = "12,4";
      font-family = "FiraCode Nerd Font";
      font-size = 12;
      confirm-close-surface = true;

      keybind = [
        "super+i=inspector:toggle"
        "super+r=reload_config"
      ];

      quick-terminal-animation-duration = 0.08;
      background-blur = true;
    };
  };
}
