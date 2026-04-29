{ lib, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/amdgpu
    ../../modules/retroarch
  ];

  networking.hostName = "amd";
}
