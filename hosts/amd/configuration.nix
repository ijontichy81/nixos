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
    ../../modules/comfyui
  ];

  networking.hostName = "amd";

  services.greetd.enable = lib.mkForce false;

  services.displayManager.sessionPackages = [
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
  ];

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
  ];

  hardware.bluetooth.enable = true;
}
