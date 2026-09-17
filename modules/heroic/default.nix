{ pkgs, lib, ... }:

{
  environment.systemPackages = [
    pkgs.heroic
  ];

  programs.gamescope.enable = true;

  programs.gamemode = {
    enable = true;
    # Note: caelestia idle-inhibit hooks removed with the shell;
    # DMS handles idle/lock itself. Re-add hooks here if needed.
  };
}