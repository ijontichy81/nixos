{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (audacity.overrideAttrs (old: {
      cmakeFlags = builtins.map (flag:
        if pkgs.lib.hasPrefix "-Daudacity_has_vst3=" flag
        then "-Daudacity_has_vst3=On"
        else flag
      ) old.cmakeFlags;
    }))
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
    ffmpeg
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
    cava
    winboat
  ];
}
