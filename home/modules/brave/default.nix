{ config, pkgs, lib, ... }: {
  home.packages = [
    (pkgs.writeScriptBin "brave" ''
      #!${lib.getExe pkgs.bash}
      export NIXOS_OZONE_WL=1
      export LD_LIBRARY_PATH="${pkgs.wayland}/lib:${pkgs.mesa}/lib:${pkgs.libGL}/lib:${pkgs.egl}/lib:${pkgs.gtk3}/lib:$LD_LIBRARY_PATH"
      export GSETTINGS_SCHEMA_DIR="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas:${pkgs.gtk3}/share/gsettings-schemas"
      export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share:${pkgs.gtk3}/share:$XDG_DATA_DIRS"
      exec -a "$0" "${pkgs.brave}/bin/.brave-wrapped" --ozone-platform=wayland "$@"
    '')
    pkgs.wayland
    pkgs.mesa
    pkgs.libGL
    pkgs.egl
    pkgs.gsettings-desktop-schemas
    pkgs.gtk3
    pkgs.xdg-desktop-portal-gtk
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave.desktop";
    "x-scheme-handler/http" = "brave.desktop";
    "x-scheme-handler/https" = "brave.desktop";
    "x-scheme-handler/about" = "brave.desktop";
    "x-scheme-handler/unknown" = "brave.desktop";
  };
}