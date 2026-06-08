{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.stable-diffusion-cpp-rocm ];

  networking.firewall.allowedTCPPorts = [ 1234 ];

  systemd.services.sd-server = {
    description = "stable-diffusion.cpp web UI server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = lib.mkForce [ ];
    path = [ pkgs.stable-diffusion-cpp-rocm ];

    serviceConfig = {
      Type = "simple";
      User = "marco";
      Group = "vip";
      ExecStart = "${pkgs.stable-diffusion-cpp-rocm}/bin/sd-server --listen-ip 127.0.0.1 --listen-port 1234";
      Restart = "on-failure";
      RestartSec = 5;
    };

    environment = {
      ROC_ENABLE_PRE_VEGA = "1";
    };
  };
}
