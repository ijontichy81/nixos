{ pkgs, ... }:

{
  services.vicinae = {
    enable = true;
    systemd.enable = true;
  };
}
