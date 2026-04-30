{ config, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza -la --icons --git";
    };
  };
}
