{ config, pkgs, lib, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "ponfpcnoihfmfllpaingbgckeeldkhle;https://clients2.google.com/service/update2/crx"
      "gebbhagfogifgggkldgodflihgfeippi;https://clients2.google.com/service/update2/crx"
      "dbepggeogbaibhgnhhndojpepiihcmeb;https://clients2.google.com/service/update2/crx"
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave.desktop";
    "x-scheme-handler/http" = "brave.desktop";
    "x-scheme-handler/https" = "brave.desktop";
    "x-scheme-handler/about" = "brave.desktop";
    "x-scheme-handler/unknown" = "brave.desktop";
  };
}