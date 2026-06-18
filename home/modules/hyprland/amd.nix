{ config, pkgs, lib, inputs, ... }:

let
  mod = "SUPER";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    systemd.enable = true;

    settings = {
      monitor = [
        ", preferred, auto, 1"
      ];

      xwayland = {
        enabled = true;
      };

      input = {
        kb_layout = "us,de";
        kb_options = "grp:alt_space_toggle";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.5;
        };
        sensitivity = 0;
      };

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgba(CBA6F7FF) rgba(a8ffb5FF) 135deg";
        "col.inactive_border" = "rgba(45475A88)";
        cursor_inactive_timeout = 3;
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        active_opacity = 0.88;
        inactive_opacity = 0.75;
        fullscreen_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1E1E2ECC)";
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.9;
          popups = true;
          popups_ignorealpha = 0.6;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuart, 0.25, 1, 0.5, 1"
          "overshoot, 0.05, 0.9, 0.1, 1.1"
        ];
        animation = [
          "windows, 1, 4, easeOutQuart, popin"
          "windowsOut, 1, 4, easeOutQuart, popin"
          "fade, 1, 4, easeOutQuart"
          "workspaces, 1, 4, easeOutQuart, slide"
          "border, 1, 4, overshoot"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
        split_width_multiplier = 1.0;
        smart_split = false;
        smart_resizing = true;
        permanent_direction_override = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
        workspace_swipe_distance = 300;
        workspace_swipe_invert = false;
        workspace_swipe_min_fingers = 3;
        workspace_swipe_cancel_ratio = 0.15;
      };

      windowrule = [
        "float, ^(pavucontrol)$"
        "float, ^(blueman-manager)$"
        "float, title:^(Volume Control)$"
        "float, title:^(File Operation Progress)$"
        "float, title:^(Picture in picture)$"
        "float, title:^(Library)$"
        "opacity 0.98 0.90, ^(firefox)$"
        "opacity 0.90 0.75, ^(spotify)$"
        "opacity 0.98 0.88, ^(alacritty)$"
        "opacity 0.98 0.88, ^(ghostty)$"
        "opacity 0.98 0.88, ^(org.gnome.Nautilus)$"
      ];

      bind = [
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"
        "$mod, Y, fullscreenstate, -1 2"
        "$mod, R, togglesplit"
        "$mod, Tab, overview:toggle"
        "$mod, Left, movefocus, l"
        "$mod, Right, movefocus, r"
        "$mod, Up, movefocus, u"
        "$mod, Down, movefocus, d"
        "$mod SHIFT, Left, movewindow, l"
        "$mod SHIFT, Right, movewindow, r"
        "$mod SHIFT, Up, movewindow, u"
        "$mod SHIFT, Down, movewindow, d"
        "$mod, B, exec, firefox"
        "$mod, T, exec, ghostty"
        "$mod, E, exec, nautilus"
        "$mod, M, exec, spotify"

        "$mod, Space, exec, vicinae open"
        "$mod SHIFT, V, exec, vicinae vicinae://launch/clipboard/history"
        "$mod SHIFT, S, exec, vicinae vicinae://launch/files/search"
        "$mod SHIFT, E, exec, vicinae vicinae://open?fallbackText=emoji"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      env = [
        "XCURSOR_SIZE,32"
        "XCURSOR_THEME,catppuccin-mocha-green-cursors"
      ];

      exec-once = [
        "dconf write /org/gnome/desktop/interface/icon-theme \"'Papirus-Dark'\""
        "wl-clip-persist --clipboard both"
        "sh -c 'wl-paste --type text --watch cliphist store'"
        "sh -c 'wl-paste --type image --watch cliphist store'"
        "vicinae server"
        "vicinae theme set catppuccin-mocha"
        "ghostty"
        "xwayland-satellite"
      ];
    };
  };

}
