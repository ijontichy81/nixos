{ ... }:

{
  programs.opencode = {
    enable = true;
    settings = {
      model = "Big Pickle";
      autoupdate = false;
    };
    tui = {
      theme = "catppuccin-macchiato";
    };
  };
}
