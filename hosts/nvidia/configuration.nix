{ lib, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/nvidia
  ];

  networking.hostName = "nvidia";
  
  fileSystems."~/organisation" = {
  device = "//192.168.178.10/Organisation/";
  fsType = "cifs";
  options = [ "credentials=/etc/smb-credentials" "vers=3.0" "x-systemd.automount" ];
};
  environment.etc."smb-credentials".text = ''
  username=marco.benther
  password=verwaltung
'';
}
