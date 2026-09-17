{ lib, pkgs, inputs, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/nvidia
  ];

  networking.hostName = "nvidia";

  # greetd is nvidia's display manager; disable sddm
  services.displayManager.sddm.enable = lib.mkForce false;

  # UWSM-managed Hyprland (mirrors amd)
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
    extraPortals = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ];
    configPackages = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
    ];
  };

  services.openssh.enable = true;

  age.secrets.smb-credentials.file = ../../secrets/smb-credentials.age;

  fileSystems."/home/marco/organisation" = {
    device = "//192.168.178.10/Organisation/";
    fsType = "cifs";
    options = [ "credentials=/run/agenix/smb-credentials" "vers=3.0" "x-systemd.automount" ];
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
  };

  hardware.bluetooth.enable = true;

  environment.systemPackages = [ pkgs.system-config-printer ];
}
