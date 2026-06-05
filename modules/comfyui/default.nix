{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    comfy-ui
    comfy-cli
  ];

  networking.firewall.allowedTCPPorts = [ 8188 ];
}
