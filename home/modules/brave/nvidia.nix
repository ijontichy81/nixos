{ config, pkgs, lib, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "ponfpcnoihfmfllpaingbgckeeldkhle"
      "gebbhagfogifgggkldgodflihgfeippi"
      "dbepggeogbaibhgnhhndojpepiihcmeb"
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
