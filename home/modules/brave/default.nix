{ config, pkgs, ... }: {
  programs.brave = {
    enable = true;
    extensions = [
      # Add your extension IDs here, for example:
      # "cjpalhdlnbpafiamejdnhcphjbkeiagm"  # uBlock Origin
      # "nngceckbapebfimnlniiiahkandfilfh"  # Privacy Badger
    ];
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };
}