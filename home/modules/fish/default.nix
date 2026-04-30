{ osConfig, ... }:

{
  imports = [
    (if osConfig.networking.hostName == "amd" then ./amd.nix else ./nvidia.nix)
  ];
}
