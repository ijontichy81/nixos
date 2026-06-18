{ lib, pkgs, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/amdgpu
    ../../modules/retroarch
    ../../modules/steam
    ../../modules/quickshell
    ../../modules/hyprland
    ../../modules/sddm
    ../../modules/heroic
    ../../modules/comfyui
  ];

  networking.hostName = "amd";

  services.greetd.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    protonup-qt
    ddcutil
    brightnessctl
    cava
    lm_sensors
    aubio
    material-symbols
    nerd-fonts.caskaydia-cove
    swappy
  ];

  hardware.bluetooth.enable = true;
}
