{ config, lib, pkgs, ... }:

let
  koboldcpp-wrapped = pkgs.writeShellScriptBin "koboldcpp" ''
    RUNDIR=$(mktemp -d)
    ln -sfn "${pkgs.koboldcpp}/bin" "$RUNDIR/embd_res"
    ln -sfn "${pkgs.koboldcpp}/bin/koboldcpp.unwrapped" "$RUNDIR/koboldcpp"
    exec "$RUNDIR/koboldcpp" "$@"
  '';
in
{
  environment.systemPackages = [ koboldcpp-wrapped ];

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
      ExecStart = "${koboldcpp-wrapped}/bin/koboldcpp --usevulkan --host 127.0.0.1 --port 5001 --sdmodel /home/marco/ComfyUI/models/checkpoints/illu/animosity_illustriousV11.safetensors --sdflashattention --sdoffloadcpu";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
