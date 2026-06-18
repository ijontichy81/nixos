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
        wallpaperDir = "~/Pictures/Wallpapers";
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
    };
  };
}
