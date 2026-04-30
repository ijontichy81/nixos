{ lib, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/amdgpu
    ../../modules/retroarch
    ../../modules/steam
    ../../modules/quickshell
    ../../modules/sddm-amd
  ];

  networking.hostName = "amd";

  services.greetd.enable = lib.mkForce false;
}
