{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.koboldcpp ];

  networking.firewall.allowedTCPPorts = [ 5001 ];

  systemd.services.koboldcpp = {
    description = "KoboldCPP AI server with Vulkan GPU support";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = lib.mkForce [ ];

    serviceConfig = {
      Type = "simple";
      User = "marco";
      Group = "vip";
      ExecStart = "${pkgs.koboldcpp}/bin/koboldcpp --usevulkan --host 127.0.0.1 --port 5001 --sdmodel /home/marco/ComfyUI/models/checkpoints/illu/animosity_illustriousV11.safetensors --sdflashattention --sdoffloadcpu";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
