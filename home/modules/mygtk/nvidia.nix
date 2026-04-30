{ config, pkgs, lib, ... }:

let
  cfg = config.mygtk;
  themePackage = pkgs.catppuccin-gtk.override {
    variant = cfg.theme;
    accents = [ cfg.accent ];
    size = "standard";
  };
  themeName = "catppuccin-${cfg.theme}-${cfg.accent}-standard";
  papirusThemePackage = pkgs.catppuccin-papirus-folders.override {
    flavor = cfg.theme;
    accent = cfg.accent;
  };
in
{
  options.mygtk = {
    enable = lib.mkEnableOption "Enable GTK theming";

    theme = lib.mkOption {
      type = lib.types.enum [ "latte" "frappe" "macchiato" "mocha" ];
      default = "macchiato";
      description = "Catppuccin flavor";
    };

    accent = lib.mkOption {
      type = lib.types.enum [ "blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow" ];
      default = "green";
      description = "Catppuccin accent color";
    };

    iconTheme = lib.mkOption {
      type = lib.types.enum [ "Papirus-Dark" "Papirus-Light" "Adwaita" "Qogir-dark" "Qogir" ];
      default = "Papirus-Dark";
      description = "Icon theme name";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${cfg.iconTheme}
      gtk-font-name=FiraCode Nerd Font 11
      gtk-application-prefer-dark-theme=1
    '';
    xdg.configFile."gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-icon-theme-name=${cfg.iconTheme}
      gtk-application-prefer-dark-theme=1
    '';
    xdg.configFile."gtk-4.0/gtk.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk.css";
    xdg.configFile."gtk-4.0/gtk-dark.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk-dark.css";
    xdg.configFile."gtk-4.0/assets".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/assets";


    home.packages = [ themePackage papirusThemePackage ];

    home.sessionVariables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
    };
  };
}
