{
  pkgs,
  config,
  lib,
  ...
}: let
  palette = config.colorScheme.palette;
  wallpaper = /home/marco/Pictures/papes/purple1.png;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = {
      FormPosition = "left";
      Blur = "4.0";
      Background = wallpaper;
      HourFormat = "h:mm AP";
      HeaderTextColor = "#${palette.base05}";
      DateTextColor = "#${palette.base05}";
      TimeTextColor = "#${palette.base05}";
      LoginFieldTextColor = "#${palette.base05}";
      PasswordFieldTextColor = "#${palette.base05}";
      UserIconColor = "#${palette.base05}";
      PasswordIconColor = "#${palette.base05}";
      WarningColor = "#${palette.base05}";
      LoginButtonBackgroundColor = "#${palette.base01}";
      SystemButtonsIconsColor = "#${palette.base05}";
      SessionButtonTextColor = "#${palette.base05}";
      VirtualKeyboardButtonTextColor = "#${palette.base05}";
      DropdownBackgroundColor = "#${palette.base01}";
      HighlightBackgroundColor = "#${palette.base05}";
      FormBackgroundColor = "#${palette.base01}";
    };
  };
in {
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [sddm-astronaut];
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      settings = {
        X11 = {
          XkbLayout = "us";
          XkbVariant = "";
        };
      };
    };
  };

  systemd.services.display-manager.environment = {
    XKB_DEFAULT_LAYOUT = "us";
  };

  environment.systemPackages = [sddm-astronaut];
}
