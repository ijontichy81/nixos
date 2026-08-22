{ lib, pkgs, inputs, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/amdgpu
    ../../modules/retroarch
    ../../modules/steam
    ../../modules/quickshell
    #../../modules/hyprland
    ../../modules/sddm
    ../../modules/heroic
    ../../modules/koboldcpp
  ];

  networking.hostName = "amd";

  # Mesh VPN so sdgen.py can reach koboldcpp from anywhere (no port forwarding,
  # immune to dynamic IPs). Authenticate once with: sudo tailscale up
  services.tailscale.enable = true;

  # SSH for pulling files to / managing the box from phone (Termux)
  services.openssh.enable = true;

  services.greetd.enable = lib.mkForce false;

  # UWSM-managed Hyprland
  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  programs.xwayland.enable = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    configPackages = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
    ];
  };

  environment.systemPackages = with pkgs; [
    lact
    protonup-qt
    ddcutil
    brightnessctl
    cava
    lm_sensors
    aubio
    nerd-fonts.caskaydia-cove
    swappy
    qt5.qtgraphicaleffects
    qt6.qt5compat
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtquick3d
    networkmanagerapplet
    libnotify
    slurp
    grim
    realesrgan-ncnn-vulkan
  ];

  systemd.packages = [ pkgs.lact ];
  systemd.services.lactd = {
    wantedBy = [ "multi-user.target" ];
  };

  hardware.bluetooth.enable = true;
}
