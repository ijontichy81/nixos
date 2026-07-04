{ pkgs, lib, ... }:

{
  environment.systemPackages = [
    pkgs.heroic
  ];

  programs.gamescope.enable = true;

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        start = "caelestia shell idleInhibitor enable";
        end = "caelestia shell idleInhibitor disable";
      };
    };
  };
}