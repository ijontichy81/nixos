{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
    shellAliases = {
      ls = "eza -la --icons --git";
    };
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "vscode"
        "z"
      ];
    };
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      # Load powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };
}