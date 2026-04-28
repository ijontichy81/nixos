{ config, pkgs, variables, ... }:

{
  imports = [
    ./hardware-configuration.nix
./modules/amdgpu
    ./modules/zsh
  ];

  nixpkgs.overlays = [
    (import ./overlays/nautilus)
  ];
  # Cachix
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://niri.cachix.org"
      "https://vicinae.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-color-emoji
    breeze-hacked-cursor-theme
  ];

  # Set font config for emoji
  fonts.fontconfig = {
    enable = true;
    defaultFonts.emoji = [ "Noto Color Emoji" ];
  };

  programs.fish.enable = true;

  # Define groups
  users.groups.vip = { };

  # Define a user account.
  users.users.marco = {
    isNormalUser = true;
    description = "marco";
    group = "vip";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.zsh;
    homeMode = "750";
    packages = with pkgs; [
    ];
  };

  # Fix home directory permissions on boot
  systemd.services.fix-home-permissions = {
    serviceConfig.Type = "oneshot";
    script = ''
      # Fix group ownership
      chgrp -R vip /home/marco
      # Ensure directories are executable
      find /home/marco -type d -exec chmod 750 {} \;
    '';
    wantedBy = [ "multi-user.target" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Firmware
  hardware.enableRedistributableFirmware = true;

  # SSD TRIM
  services.fstrim.enable = true;

  services.udisks2.enable = true;

  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    uwsm
    clinfo
    lact
    vim
    wget
    wayland
    xwayland
    libxcb-cursor
    gsettings-desktop-schemas
    dconf
    pavucontrol
    zsh-powerlevel10k
    vlc
    spotify
    jq
    inotify-tools
    curl
    
  ];

  programs.dconf.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  system.stateVersion = "25.11";
}
