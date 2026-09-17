{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];

  boot.kernelModules = [ "nvidia" "nvidia_drm" "nvidia_uvm" "nvidia_modeset" ];

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia.powerManagement.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    egl-wayland
    libva-utils
    vdpauinfo
    vulkan-tools
    nvitop
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
