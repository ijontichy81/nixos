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

  sddm.wallpaper = ../../assets/tweetney.gif;

  services.greetd.enable = lib.mkForce false;
}
