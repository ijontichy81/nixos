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
    home.activation.createGtkConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      rm -f ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
      mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
      cat > ~/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=${themeName}
gtk-icon-theme-name=${cfg.iconTheme}
gtk-font-name=FiraCode Nerd Font 11
gtk-application-prefer-dark-theme=1
EOF
      cat > ~/.config/gtk-4.0/settings.ini << EOF
[Settings]
gtk-icon-theme-name=${cfg.iconTheme}
gtk-application-prefer-dark-theme=1
EOF
    '';
    home.file."gtk-4.0/gtk.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk.css";
    home.file."gtk-4.0/gtk-dark.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk-dark.css";
    home.file."gtk-4.0/assets".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/assets";


    home.packages = [ themePackage papirusThemePackage ];

    home.sessionVariables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
    };
  };
}
