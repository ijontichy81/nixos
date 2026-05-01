{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.heroic
  ];

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}