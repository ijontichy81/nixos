{ config, pkgs, lib, ... }: {
  home.packages = [
    (pkgs.writeScriptBin "brave" ''
      #!${lib.getExe pkgs.bash}
      export LD_LIBRARY_PATH="${pkgs.wayland}/lib:${pkgs.mesa}/lib:${pkgs.libGL}/lib:${pkgs.gtk3}/lib:${pkgs.xdg-desktop-portal}/lib:$LD_LIBRARY_PATH"
      export GSETTINGS_SCHEMA_DIR="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas:${pkgs.gtk3}/share/gsettings-schemas"
      export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share:${pkgs.gtk3}/share:${pkgs.xdg-desktop-portal}/share:$XDG_DATA_DIRS"
      exec -a "$0" "${pkgs.brave}/bin/.brave-wrapped" --ozone-platform=wayland "$@"
    '')
    pkgs.wayland
    pkgs.mesa
    pkgs.libGL
    pkgs.gsettings-desktop-schemas
    pkgs.gtk3
    pkgs.xdg-desktop-portal
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };
}