{ config, pkgs, lib, ... }: {
  home.packages = [
    (pkgs.writeScriptBin "brave" ''
      #!${lib.getExe pkgs.bash}
      export NIXOS_OZONE_WL=1
      exec -a "$0" "${pkgs.brave}/bin/.brave-wrapped" --ozone-platform=wayland "$@"
    '')
    pkgs.wayland
    pkgs.mesa
    pkgs.gsettings-desktop-schemas
    pkgs.gtk3
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave.desktop";
    "x-scheme-handler/http" = "brave.desktop";
    "x-scheme-handler/https" = "brave.desktop";
    "x-scheme-handler/about" = "brave.desktop";
    "x-scheme-handler/unknown" = "brave.desktop";
  };
}