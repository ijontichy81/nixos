{ config, pkgs, lib, ... }: {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WAYLAND_DISPLAY = "wayland-1";
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave.desktop";
    "x-scheme-handler/http" = "brave.desktop";
    "x-scheme-handler/https" = "brave.desktop";
    "x-scheme-handler/about" = "brave.desktop";
    "x-scheme-handler/unknown" = "brave.desktop";
  };
}