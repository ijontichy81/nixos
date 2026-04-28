{ ... }:

{
  programs.opencode = {
    enable = true;
    settings = {
      model = "opencode/MiniMax M2.5 Free";
      autoupdate = false;
    };
    tui = {
      theme = "catppuccin-macchiato";
    };
  };
}