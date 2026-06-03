{ pkgs, lib, ... }:

{
  imports = [
    ../../common.nix
    ./hardware-configuration.nix
    ../../modules/nvidia
    ../../modules/quickshell
  ];

  services.openssh.enable = true;

  age.secrets.smb-credentials.file = ../../secrets/smb-credentials.age;

  networking.hostName = "nvidia";

  fileSystems."/home/marco/organisation" = {
    device = "//192.168.178.10/Organisation/";
    fsType = "cifs";
    options = [ "credentials=/run/agenix/smb-credentials" "vers=3.0" "x-systemd.automount" ];
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
  };

  hardware.bluetooth.enable = true;

  environment.systemPackages = [ pkgs.system-config-printer ];
}
