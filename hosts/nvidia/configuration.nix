{ pkgs, lib, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/nvidia
    ../../modules/quickshell
  ];

  networking.hostName = "nvidia";
  
  fileSystems."/home/marco/organisation" = {
  device = "//192.168.178.10/organisation/";
  fsType = "cifs";
  options = [ "credentials=/etc/smb-credentials" "vers=3.0" "x-systemd.automount" ];
};
  environment.etc."smb-credentials".text = ''
  username=marco.benther
  password=verwaltung
  domain=TEMPELHOF
  '';

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
  };

  environment.systemPackages = [ pkgs.system-config-printer ];
}
