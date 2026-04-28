{ config, pkgs, lib, ... }: {
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "wayland";
    OZONE_PLATFORM = "wayland";
  };

  home.packages = [
    pkgs.brave
    pkgs.wayland
    pkgs.mesa
    pkgs.gsettings-desktop-schemas
    pkgs.gtk3
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };
}