{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.marco = {
      settings = {
        "browser.tabs.loadInBackground" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
        "browser.download.defaultFolder" = "${config.home.homeDirectory}/Downloads";
        "browser.download.useDownloadDir" = true;
        "browser.download.manager.showWhenStarting" = false;
        "browser.download.manager.focusWhenStarting" = false;
        "browser.download.manager.alwaysShowPanel" = false;
        "security.sandbox.content.writeepath1" = "${config.home.homeDirectory}/Downloads/**";
        "security.sandbox.content.writeepath2" = "${config.home.homeDirectory}/Pictures/**";
        "security.sandbox.content.writeepath3" = "${config.home.homeDirectory}/Documents/**";
        "security.sandbox.content.writeepath4" = "${config.home.homeDirectory}/Music/**";
        "security.sandbox.content.writeepath5" = "${config.home.homeDirectory}/Templates/**";
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}
