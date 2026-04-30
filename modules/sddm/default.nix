{
  pkgs,
  lib,
  inputs,
  ...
}: let
  wallpaper = "/home/marco/Pictures/papes/purple1.png";
  text = "cdd6f4";
  surface = "313244";
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = {
      FormPosition = "left";
      Blur = "4.0";
      Background = wallpaper;
      HourFormat = "h:mm AP";
      HeaderTextColor = "#${text}";
      DateTextColor = "#${text}";
      TimeTextColor = "#${text}";
      LoginFieldTextColor = "#${text}";
      PasswordFieldTextColor = "#${text}";
      UserIconColor = "#${text}";
      PasswordIconColor = "#${text}";
      WarningColor = "#${text}";
      LoginButtonBackgroundColor = "#${surface}";
      SystemButtonsIconsColor = "#${text}";
      SessionButtonTextColor = "#${text}";
      VirtualKeyboardButtonTextColor = "#${text}";
      DropdownBackgroundColor = "#${surface}";
      HighlightBackgroundColor = "#${text}";
      FormBackgroundColor = "#${surface}";
    };
  };
in {
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [sddm-astronaut];
      enable = true;
      theme = "sddm-astronaut-theme";
      settings = {
        X11 = {
          XkbLayout = "us";
          XkbVariant = "";
        };
      };
    };
    defaultSession = "niri";
    sessionPackages = [
      inputs.niri.packages.x86_64-linux.niri-unstable
    ];
  };

  services.xserver.enable = true;

  services.libinput.enable = true;

  environment.systemPackages = [
    sddm-astronaut
    inputs.niri.packages.x86_64-linux.niri-unstable
  ];

  systemd.services.display-manager.environment = {
    XKB_DEFAULT_LAYOUT = "us";
  };
}
