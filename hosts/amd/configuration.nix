{ lib, pkgs, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/amdgpu
    ../../modules/retroarch
    ../../modules/steam
    ../../modules/quickshell
    ../../modules/sddm
    ../../modules/heroic
    ../../modules/comfyui
  ];

  networking.hostName = "amd";

  services.greetd.enable = lib.mkForce false;

  environment.systemPackages = [ pkgs.protonup-qt ];

  hardware.bluetooth.enable = true;
}
