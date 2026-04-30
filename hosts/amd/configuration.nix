{ lib, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/amdgpu
    ../../modules/retroarch
    ../../modules/steam
    ../../modules/quickshell
    ../../modules/sddm
  ];

  networking.hostName = "amd";

  services.greetd.enable = false;
}
