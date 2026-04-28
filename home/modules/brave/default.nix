{ config, pkgs, lib, ... }: {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  home.packages = [
    pkgs.brave
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