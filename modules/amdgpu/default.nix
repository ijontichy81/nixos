{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.amdgpu.opencl.enable = true;
  hardware.amdgpu.initrd.enable = true;

  nixpkgs.config.rocmSupport = true;

  environment.systemPackages = with pkgs; [
    clinfo
  ];

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

  

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_DISABLE_SOCKET_PROCESS_SANDBOX = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}