{ lib, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/nvidia
  ];

  networking.hostName = "nvidia";
}
