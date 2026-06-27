{
  pkgs,
  lib,
  inputs,
  ...
}: let
  wallpaper = builtins.path { path = ../../assets/tweetney.webm; name = "sddm-wallpaper.webm"; };
  sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  }).overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      configFile="$out/share/sddm/themes/sddm-astronaut-theme/Themes/pixel_sakura.conf"
      chmod +w "$configFile" "$out/share/sddm/themes/sddm-astronaut-theme/Themes"
      substitute "$configFile" /tmp/pixel_sakura_patched.conf \
        --replace-fail 'Background="Backgrounds/pixel_sakura.gif"' 'Background="${wallpaper}"' \
        --replace-fail 'HeaderTextColor="#3d495b"' 'HeaderTextColor="#cdd6f4"' \
        --replace-fail 'DateTextColor="#3d495b"' 'DateTextColor="#cdd6f4"' \
        --replace-fail 'TimeTextColor="#3d495b"' 'TimeTextColor="#cdd6f4"' \
        --replace-fail 'LoginFieldTextColor="#3d495b"' 'LoginFieldTextColor="#cdd6f4"' \
        --replace-fail 'PasswordFieldTextColor="#3d495b"' 'PasswordFieldTextColor="#cdd6f4"' \
        --replace-fail 'UserIconColor="#3d495b"' 'UserIconColor="#cdd6f4"' \
        --replace-fail 'PasswordIconColor="#3d495b"' 'PasswordIconColor="#cdd6f4"' \
        --replace-fail 'WarningColor="#3d495b"' 'WarningColor="#cdd6f4"' \
        --replace-fail 'SystemButtonsIconsColor="#3d495b"' 'SystemButtonsIconsColor="#cdd6f4"' \
        --replace-fail 'SessionButtonTextColor="#3d495b"' 'SessionButtonTextColor="#cdd6f4"' \
        --replace-fail 'VirtualKeyboardButtonTextColor="#3d495b"' 'VirtualKeyboardButtonTextColor="#cdd6f4"' \
        --replace-fail 'LoginButtonBackgroundColor="#3d495b"' 'LoginButtonBackgroundColor="#313244"' \
        --replace-fail 'DropdownBackgroundColor="#3d495b"' 'DropdownBackgroundColor="#313244"' \
        --replace-fail 'HighlightBackgroundColor="#3d495b"' 'HighlightBackgroundColor="#cdd6f4"' \
        --replace-fail 'FormBackgroundColor="#21222C"' 'FormBackgroundColor="#313244"'
      cp /tmp/pixel_sakura_patched.conf "$configFile"
    '';
  });
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
    defaultSession = "hyprland-uwsm";
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
    QT_QPA_PLATFORM = "xcb";
    GDK_BACKEND = "x11";
  };
}
