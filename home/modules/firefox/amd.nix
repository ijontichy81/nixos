{ config, pkgs, ... }:

{
  home.file."firefox-gnome-theme" = {
    target = ".mozilla/firefox/marco/chrome/firefox-gnome-theme";
    source = pkgs.fetchFromGitHub {
      owner = "rafaelmardojai";
      repo = "firefox-gnome-theme";
      rev = "91ca1f82d717b02ceb03a3f423cbe8082ebbb26d";
      hash = "sha256-S79Hqn2EtSxU4kp99t8tRschSifWD4p/51++0xNWUxw=";
    };
  };

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
        "gnomeTheme.hideSingleTab" = true;
        "gnomeTheme.bookmarksToolbarUnderTabs" = true;
        "gnomeTheme.normalWidthTabs" = false;
        "gnomeTheme.tabsAsHeaderbar" = false;
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
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
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
