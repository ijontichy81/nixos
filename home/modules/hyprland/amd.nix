{ config, pkgs, lib, inputs, ... }:

let
  mod = "SUPER";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    configType = "lua";
    systemd.enable = true;

    settings = {
      mod = { _var = mod; };

      monitor = [{
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      }];

      config = {
        general = {
          gaps_in = 6;
          gaps_out = 12;
          border_size = 2;
          col = { };
          layout = "dwindle";
          allow_tearing = false;
          resize_on_border = false;
        };

        decoration = {
          rounding = 10;
          active_opacity = 0.88;
          inactive_opacity = 0.75;
          fullscreen_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 20;
            render_power = 3;
          };
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

        animations = { enabled = true; };

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

        dwindle = {
          preserve_split = true;
          force_split = 2;
          split_width_multiplier = 1.0;
          smart_split = false;
          smart_resizing = true;
          permanent_direction_override = true;
        };

        xwayland = { enabled = true; };
      };

      device = [
        {
          name = "soundcore-q21i-nc-(avrcp)";
          kb_layout = "us,de";
          kb_options = "grp:alt_space_toggle";
        }
      ];

      curve = [
        {
          _args = [
            "easeOutQuart"
            { type = "bezier"; points = [[0.25 1] [0.5 1]]; }
          ];
        }
        {
          _args = [
            "overshoot"
            { type = "bezier"; points = [[0.05 0.9] [0.1 1.1]]; }
          ];
        }
      ];

      animation = [
        { leaf = "windows"; enabled = true; speed = 4; bezier = "easeOutQuart"; style = "popin"; }
        { leaf = "windowsOut"; enabled = true; speed = 4; bezier = "easeOutQuart"; style = "popin"; }
        { leaf = "fade"; enabled = true; speed = 4; bezier = "easeOutQuart"; }
        { leaf = "workspaces"; enabled = true; speed = 4; bezier = "easeOutQuart"; style = "slide"; }
        { leaf = "border"; enabled = true; speed = 4; bezier = "overshoot"; }
      ];

      env = [
        { _args = ["XCURSOR_SIZE" "32"]; }
        { _args = ["XCURSOR_THEME" "catppuccin-mocha-green-cursors"]; }
      ];

      window_rule = [
        { match = { class = "^(pavucontrol)$"; }; float = true; }
        { match = { class = "^(blueman-manager)$"; }; float = true; }
        { match = { title = "^(Volume Control)$"; }; float = true; }
        { match = { title = "^(File Operation Progress)$"; }; float = true; }
        { match = { title = "^(Picture in picture)$"; }; float = true; }
        { match = { title = "^(Library)$"; }; float = true; }
        { match = { class = "^(firefox)$"; }; opacity = "0.98 0.90"; }
        { match = { class = "^(Spotify)$"; }; opacity = "0.90 0.75"; workspace = "3 silent"; }
        { match = { class = "^(alacritty)$"; }; opacity = "0.98 0.88"; }
        { match = { class = "^(ghostty)$"; }; opacity = "0.98 0.88"; }
        { match = { class = "^(org.gnome.Nautilus)$"; }; opacity = "0.98 0.88"; }
      ];

      bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 1"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 1})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 2"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 2})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 3"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 3})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 4"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 4})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 5"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 5})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 6"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 6})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 7"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 7})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 8"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 8})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + 9"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 9})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 1"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 1})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 2"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 2})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 3"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 3})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 4"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 4})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 5"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 5})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 6"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 6})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 7"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 7})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 8"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 8})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + 9"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 9})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + Q"'')
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + Q"'')
            (lib.generators.mkLuaInline "hl.dsp.exit()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + F"'')
            (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + F"'')
            (lib.generators.mkLuaInline "hl.dsp.window.float({action = \"toggle\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + Y"'')
            (lib.generators.mkLuaInline "hl.dsp.window.fullscreen_state({internal = -1, client = 2})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + R"'')
            (lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + left"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"left\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + right"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"right\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + up"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"up\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + down"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"down\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + left"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({direction = \"left\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + right"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({direction = \"right\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + up"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({direction = \"up\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + down"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({direction = \"down\"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + B"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"firefox\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + T"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"ghostty\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + E"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"nautilus\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + M"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"spotify\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + Space"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae open\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + V"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae vicinae://launch/clipboard/history\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + S"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae vicinae://launch/files/search\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + SHIFT + E"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae vicinae://open?fallbackText=emoji\")")
          ];
        }
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
            { locked = true; }
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + mouse:272"'')
            (lib.generators.mkLuaInline "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mod .. " + mouse:273"'')
            (lib.generators.mkLuaInline "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''"CTRL + SHIFT + S"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"caelestia shell nexus open\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''"CTRL + B"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"bash -c 'if caelestia scheme get -m | grep -q dark; then caelestia scheme set -m light; sed -i \\\"s/gtk-application-prefer-dark-theme=1/gtk-application-prefer-dark-theme=0/\\\" ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini; else caelestia scheme set -m dark; sed -i \\\"s/gtk-application-prefer-dark-theme=0/gtk-application-prefer-dark-theme=1/\\\" ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini; fi; pkill nautilus; true'\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''"CTRL + SHIFT + B"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"/home/marco/nixos/bin/switch-theme.sh /home/marco/nixos/assets/light/bed.jpg\")")
          ];
        }
      ];

      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("wl-clip-persist --clipboard both")
              hl.exec_cmd("sh -c 'wl-paste --type text --watch cliphist store'")
              hl.exec_cmd("sh -c 'wl-paste --type image --watch cliphist store'")
              hl.exec_cmd("vicinae server")
              hl.exec_cmd("vicinae theme set catppuccin-mocha")
              hl.exec_cmd("ghostty")
              hl.exec_cmd("xwayland-satellite")
              hl.exec_cmd("spotify")
            end
          '')
        ];
      };
    };
  };
}
