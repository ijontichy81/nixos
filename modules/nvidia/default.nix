{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia.opencl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaPersistenced = true;

  services.xserver.videoDrivers = [ "nvidia" ];
}