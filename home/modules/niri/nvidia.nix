{ config, pkgs, lib, ... }:

{
  programs.niri = {
    enable = true;
  };

  xdg.configFile."niri/config.kdl".text = ''
    prefer-no-csd
    workspace "🐚"
    workspace "🌐"
    workspace "🎵"
    environment {
      GTK_ICON_THEME "Papirus-Dark"
      XCURSOR_THEME "catppuccin-mocha-green-cursors"
      XCURSOR_SIZE "32"
    }
    cursor {
      xcursor-theme "catppuccin-mocha-green-cursors"
      xcursor-size 32
      hide-when-typing
    }
    input {
      keyboard {
        xkb {
          layout "us,de"
          options "grp:alt_space_toggle"
        }
      }
    }
    layout {
      gaps 25
      default-column-width { proportion 0.5; }
      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }
      always-center-single-column
      focus-ring {
        width 2
      }
    }

    window-rule {
      geometry-corner-radius 10
      clip-to-geometry true
    }
    window-rule {
      match is-active=true
      opacity 0.88
    }
    window-rule {
      match is-active=false
      opacity 0.75
    }

    window-rule {
      match app-id="firefox"
      open-on-workspace "🌐"
      open-maximized-to-edges true
      match is-active=true
      opacity 0.98
    }
    window-rule {
      match app-id="firefox"
      match is-active=false
      opacity 0.90
    }
    window-rule {
      match app-id="spotify"
      open-on-workspace "🎵"
      match is-active=true
      opacity 0.90
    }
    window-rule {
      match app-id="spotify"
      match is-active=false
      opacity 0.75
    }
    window-rule {
      match app-id="alacritty"
      default-column-width { proportion 0.5; }
      match is-active=true
      opacity 0.98
    }
    window-rule {
      match app-id="alacritty"
      default-column-width { proportion 0.5; }
      match is-active=false
      opacity 0.88
    }
    window-rule {
      match app-id="nautilus"
      default-column-width { proportion 0.5; }
    }
    window-rule {
      match app-id="ghostty"
      default-column-width { proportion 0.5; }
      match is-active=true
      opacity 0.98
    }
    window-rule {
      match app-id="ghostty"
      default-column-width { proportion 0.5; }
      match is-active=false
      opacity 0.88
    }

    binds {
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }

      Mod+Shift+Q { quit; }
      Mod+Left { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up { focus-workspace-up; }
      Mod+Down { focus-workspace-down; }
      Mod+Shift+Left { move-column-left; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+Up { move-window-to-workspace-up; }
      Mod+Shift+Down { move-window-to-workspace-down; }
      Mod+Q { close-window; }
      Mod+F { fullscreen-window; }
      Mod+Shift+F { maximize-window-to-edges ; }
      Mod+Y { switch-focus-between-floating-and-tiling; }
      Mod+R { switch-preset-column-width; }
      Mod+Tab { toggle-overview; }

      Mod+B { spawn "firefox"; }
      Mod+T { spawn "ghostty"; }
      Mod+E { spawn "nautilus"; }
      Mod+M { spawn "spotify"; }

      Mod+Space repeat=false { spawn "vicinae" "open"; }
      Mod+Shift+V repeat=false { spawn "vicinae" "vicinae://launch/clipboard/history"; }
      Mod+Shift+S repeat=false { spawn "vicinae" "vicinae://launch/files/search"; }
      Mod+Shift+E repeat=false { spawn "vicinae" "vicinae://open?fallbackText=emoji"; }

      XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
      XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
      XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
    }

    spawn-at-startup "dconf" "write" "/org/gnome/desktop/interface/icon-theme" "'Papirus-Dark'"
    spawn-at-startup "wl-clip-persist" "--clipboard" "both"
    spawn-at-startup "sh" "-c" "wl-paste --type text --watch cliphist store"
    spawn-at-startup "sh" "-c" "wl-paste --type image --watch cliphist store"
    spawn-at-startup "ghostty"
  '';
}
