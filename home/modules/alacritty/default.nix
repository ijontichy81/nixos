{ config, ... }:

{
  programs.alacritty.settings = {
    window.padding = { x = 10; y = 10; };
    colors = {
      primary = {
        background = "#${config.colorScheme.palette.base00}";
        foreground = "#${config.colorScheme.palette.base05}";
      };
      normal = {
        black   = "#${config.colorScheme.palette.base00}";
        red     = "#${config.colorScheme.palette.base08}";
        green   = "#${config.colorScheme.palette.base0B}";
        yellow  = "#${config.colorScheme.palette.base0A}";
        blue    = "#${config.colorScheme.palette.base0D}";
        magenta = "#${config.colorScheme.palette.base0E}";
        cyan    = "#${config.colorScheme.palette.base0C}";
        white   = "#${config.colorScheme.palette.base05}";
      };
    };
  };
}