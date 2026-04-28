{ config, pkgs, lib, ... }: {
  home.packages = [
    (pkgs.writeScriptBin "brave" ''
      #!${lib.getExe pkgs.bash}
      exec -a "$0" "${pkgs.brave}/bin/.brave-wrapped" --ozone-platform=wayland "$@"
    '')
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };
}