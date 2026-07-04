{ pkgs, inputs, lib, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  accent = "cba6f7"; # catppuccin mauve — change this for a different accent
in
{
  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    extraCommands = ''
      crudini --set 'Themes/catppuccin/color.ini' mocha button ${accent}
      crudini --set 'Themes/catppuccin/color.ini' mocha button-active ${accent}
      crudini --set 'Themes/catppuccin/color.ini' mocha tab-active ${accent}
      crudini --set 'Themes/catppuccin/color.ini' mocha misc ${accent}
    '';

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];
    enabledCustomApps = with spicePkgs.apps; [
      newReleases
      ncsVisualizer
    ];
    enabledSnippets = with spicePkgs.snippets; [
      rotatingCoverart
      pointer
    ];
  };
}
