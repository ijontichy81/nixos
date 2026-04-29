{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    (retroarch.override {
      cores = with libretro; [
        genesis-plus-gx
        snes9x
        beetle-psx-hw
      ];
    })
  ];
}
