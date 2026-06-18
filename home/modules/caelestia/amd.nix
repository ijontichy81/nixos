{ pkgs, inputs, config, lib, ... }: {
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = {
      enabled = true;
      bar = {
        persistent = true;
        showOnHover = true;
        dragThreshold = 20;
        tray = {
          iconSubs = [
            { id = "udiskie"; icon = "drive-removable-media-usb-panel"; }
          ];
        };
        entries = [
          { id = "logo"; enabled = true; }
          { id = "workspaces"; enabled = true; }
          { id = "spacer"; enabled = true; }
          { id = "activeWindow"; enabled = true; }
          { id = "spacer"; enabled = true; }
          { id = "tray"; enabled = true; }
          { id = "clock"; enabled = true; }
          { id = "statusIcons"; enabled = true; }
          { id = "power"; enabled = true; }
        ];
      };
      launcher = {
        enabled = true;
        favouriteApps = [ ];
        hiddenApps = [ ];
      };
      utilities.toasts = {
        kbLayoutChanged = false;
        capsLockChanged = false;
        numLockChanged = false;
        kbLimit = false;
      };
      services = {
        weatherLocation = "Berlin, Germany";
        useFahrenheit = false;
        useTwelveHourClock = false;
        gpuType = "amd";
        visualiserBars = 60;
        audioIncrement = 0.1;
        brightnessIncrement = 0.1;
        maxVolume = 1.0;
        smartScheme = true;
        defaultPlayer = "Spotify";
        lyricsBackend = "Auto";
      };
      general = {
        apps = {
          terminal = [ "ghostty" ];
          audio = [ "pavucontrol" ];
          playback = [ "mpv" ];
          explorer = [ "nautilus" ];
        };
      };
      paths = {
        wallpaperDir = "~/Pictures/papes/";
      };
    };
    cli = {
      enable = true;
      settings = {
        theme = {
          enableGtk = true;
          enableTerm = true;
          enableHypr = true;
          enableSpicetify = false;
          iconTheme = "Papirus-Dark";
          iconThemeLight = "Papirus-Light";
          iconThemeDark = "Papirus-Dark";
        };
      };
      package = let
        orig = inputs.caelestia-shell.inputs.caelestia-cli.packages.${pkgs.stdenv.hostPlatform.system}.default;
        wrapper = pkgs.writeShellScript "caelestia-auto-flavour" ''
          case "$*" in
            *scheme*set*-m*light*|*scheme*set*--mode*light*)
              exec ${orig}/bin/caelestia "$@" -f latte
              ;;
            *scheme*set*-m*dark*|*scheme*set*--mode*dark*)
              exec ${orig}/bin/caelestia "$@" -f mocha
              ;;
            *)
              exec ${orig}/bin/caelestia "$@"
              ;;
          esac
        '';
      in pkgs.runCommand "caelestia-cli-auto-flavour" {
        buildInputs = [ orig wrapper ];
      } ''
        mkdir -p $out/bin
        cp ${orig}/bin/.caelestia-wrapped $out/bin/.caelestia-wrapped
        cp ${wrapper}/bin/caelestia-auto-flavour $out/bin/caelestia
        chmod +x $out/bin/caelestia
        cp -r ${orig}/lib $out/lib
        cp -r ${orig}/share $out/share
        cp -r ${orig}/nix-support $out/nix-support
      '';
    };
  };
}
