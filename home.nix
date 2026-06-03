{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./home/modules/noctalia
    ./home/modules/nixvim
    ./home/modules/niri
    ./home/modules/ghostty
    ./home/modules/alacritty
    ./home/modules/spicetify
    ./home/modules/opencode
    ./home/modules/mygtk
    ./home/modules/firefox
    ./home/modules/brave
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

  mygtk = {
    enable = true;
    theme = "macchiato";
    accent = "mauve";
    iconTheme = "Papirus-Dark";
  };

  home.sessionVariables = {
    XCURSOR_SIZE = "32";
    XCURSOR_THEME = "catppuccin-mocha-green-cursors";
    EDITOR = "nvim";
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
  };

  programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
}
