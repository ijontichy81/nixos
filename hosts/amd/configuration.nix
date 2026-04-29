{ lib, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/amdgpu
  ];

  networking.hostName = "amd";
}
