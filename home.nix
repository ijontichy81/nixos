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
    ./home/modules/mygtk
    ./home/modules/brave
    ./home/modules/firefox
    ./home/modules/fish
    ./home/modules/udiskie
    ./home/modules/vicinae
    ./home/modules/packages
    ./home/modules/fastfetch
    ./home/modules/spotify-backup
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
    EDITOR = "nvim";
    DEFAULT_BROWSER = "${pkgs.firefox-bin}/bin/firefox";
  };

  programs.niri.package = pkgs.niri-unstable;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "caelestia";
    };
  };

  home.packages = with pkgs; [
    (catppuccin-cursors.overrideAttrs (old: {
      meta = old.meta // {
        outputsToInstall = builtins.filter (o: o != "out") (builtins.getAttr "outputs" catppuccin-cursors);
      };
    }))
  ];

  home.pointerCursor.enable = true;

  stylix = {
    cursor = {
      name = "catppuccin-frappe-sapphire-cursors";
      package = pkgs.catppuccin-cursors.frappeSapphire;
      size = 32;
    };
    targets = {
      vicinae.enable = true;
      qt.enable = true;
      nixvim.enable = true;
      opencode.enable = true;
      firefox.enable = false;
      hyprland.enable = false;
    };
  };
}
