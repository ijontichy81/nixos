{ ... }:

{
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      # Same target caelestia used; started by uwsm on login.
      target = "graphical-session.target";
    };
    # Settings intentionally unmanaged so DMS owns
    # ~/.config/DankMaterialShell via its settings GUI.
    # To go declarative later, set e.g.:
    #   settings = { theme = "dark"; };
    #   clipboardSettings = { maxHistory = 25; };
  };
}
