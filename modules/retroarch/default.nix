{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.retroarch.withCores (libretro: [
      libretro.genesis-plus-gx
      libretro.snes9x
      libretro.beetle-psx-hw
    ]))
  ];
}
