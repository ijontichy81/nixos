{ config, pkgs, variables, ... }:

{
  imports = [
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

  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPortRanges = [
    { from = 5000; to = 5050; }
  ];

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
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell = pkgs.zsh;
    homeMode = "750";
    packages = with pkgs; [
    ];
  };

  # Fix home directory permissions on boot
  systemd.services.fix-home-permissions = {
    serviceConfig.Type = "oneshot";
    script = ''
      # Fix group ownership (skip mount points)
      find /home/marco -mount \( -not -user root \) -exec chgrp vip {} + 2>/dev/null || true
      # Ensure directories are executable
      find /home/marco -mount -type d -exec chmod 750 {} + 2>/dev/null || true
    '';
    wantedBy = [ "multi-user.target" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Wayland for chromium-based apps (Brave, VSCode, Discord, etc.)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Firmware
  hardware.enableRedistributableFirmware = true;

  # SSD TRIM
  services.fstrim.enable = true;

  virtualisation.docker.enable = true;

  # KVM virtualization for winboat
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  services.udisks2.enable = true;

  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    pciutils
    uwsm
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
    python313
    python313Packages.adblock
    brave
    git
    cifs-utils
    usbutils
  ];

  programs.dconf.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 256;
      };
    };

    extraConfig.pipewire-pulse."92-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "256/48000";
            pulse.default.req = "256/48000";
            pulse.max.req = "256/48000";
            pulse.min.quantum = "256/48000";
            pulse.max.quantum = "256/48000";
          };
        }
      ];
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri";
        user = "marco";
      };
    };
  };

  services.upower.enable = true;
  services.libinput.enable = true;
  services.power-profiles-daemon.enable = true;
  services.blueman.enable = true;
  services.tumbler.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.smartd = {
    enable = if config.networking.hostName == "vm" then false else true;
    autodetect = true;
  };

  environment.pathsToLink = [ "/bin" ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  system.stateVersion = "25.11";
}
