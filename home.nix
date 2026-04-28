{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nix-colors.homeManagerModules.default
    ./home/modules/noctalia
    ./home/modules/nixvim
    ./home/modules/niri
    ./home/modules/ghostty
    ./home/modules/alacritty
    ./home/modules/spicetify
    ./home/modules/opencode
    ./home/modules/firefox
    ./home/modules/brave
    ./home/modules/mygtk
    ./home/modules/fish
    ./home/modules/udiskie
    ./home/modules/vicinae
  ];

  home.username = "marco";
  home.homeDirectory = "/home/marco";
  home.stateVersion = "26.05";

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

  home.packages = with pkgs; [
    zathura
    imv
    mpv
    fastfetch
    firefox
    ghostty
    quickshell
    wl-clipboard
    xdg-utils
    libqalculate
    imagemagick
    glow
    bluez
    lxappearance
    ruff
    nil
    eza
    tree
    ncdu
    bottom
    btop
    yazi
    alacritty
    nautilus
    jq
    krita
    cliphist
    wl-clip-persist
    inotify-tools
    curl
    udiskie
    github-cli
  ];

  programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
}
