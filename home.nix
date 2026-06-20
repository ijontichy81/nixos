{ config, pkgs, inputs, osConfig, ... }:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./home/modules/nixvim
    ./home/modules/niri
    ./home/modules/hyprland
    ./home/modules/caelestia
    ./home/modules/ghostty
    ./home/modules/alacritty
    ./home/modules/spicetify
    ./home/modules/opencode
    ./home/modules/brave
    ./home/modules/firefox
    ./home/modules/fish
    ./home/modules/udiskie
    ./home/modules/vicinae
    ./home/modules/packages
    ./home/modules/fastfetch
  ];

  home.username = "marco";
  home.homeDirectory = "/home/marco";
  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;

  home.sessionVariables = {
    XCURSOR_SIZE = "32";
    XCURSOR_THEME = "catppuccin-mocha-green-cursors";
    EDITOR = "nvim";
    DEFAULT_BROWSER = "${pkgs.firefox-bin}/bin/firefox";
  };

  programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;

  stylix.targets = {
    vicinae.enable = true;
    gtk.enable = true;
    qt.enable = true;
    nixvim.enable = true;
    spicetify.enable = true;
    opencode.enable = true;
    ghostty.enable = false;
    firefox.enable = false;
    hyprland.enable = false;
    btop.enable = false;
  };
}
