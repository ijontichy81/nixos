{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zathura
    imv
    mpv
    fastfetch
    firefox-bin
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
    winboat
  ];
}
