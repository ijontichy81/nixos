# Cursor Configuration for NixOS with Niri

## Problem
Changing cursor theme and size in Niri doesn't work because:
1. Many cursor themes are bitmap (fixed size) and ignore `xcursor-size`
2. The cursor theme needs to be explicitly installed and linked for the user
3. Need to build custom variants that aren't in nixpkgs

## Solution

### 1. Create a derivation for the cursor theme (e.g., `catppuccin-mocha-mauve.nix`)

```nix
{
  lib,
  stdenvNoCC,
  inkscape,
  just,
  xcursorgen,
  catppuccin-whiskers,
  python3,
  python3Packages,
  zip,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-cursors-mocha-mauve";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "cursors";
    rev = "v2.0.0";
    hash = "sha256-qis6p+/m7+DdRDYzLq9yB2eZGpfZe5z5xRsa/1HoIG4=";
  };

  nativeBuildInputs = [
    just
    inkscape
    xcursorgen
    catppuccin-whiskers
    python3
    python3Packages.pyside6
    zip
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    just build mocha mauve
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    mv dist/catppuccin-mocha-mauve-cursors $out/share/icons/
    runHook postInstall
  '';

  meta = {
    description = "Catppuccin mocha mauve cursor theme";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
```

### 2. Add to system packages in flake.nix

```nix
({ pkgs, ... }: {
  environment.systemPackages = [ niri.packages.x86_64-linux.niri-unstable (pkgs.callPackage ./catppuccin-mocha-mauve.nix {}) ];
})
```

### 3. Link the theme for user via xdg.dataFile in flake.nix

```nix
({ pkgs, ... }: {
  home-manager.users.anon.xdg.dataFile."icons/catppuccin-mocha-mauve-cursors".source = "${pkgs.callPackage ./catppuccin-mocha-mauve.nix {}}/share/icons/catppuccin-mocha-mauve-cursors";
})
```

### 4. Set environment variables in home.nix

```nix
home.sessionVariables.XCURSOR_THEME = "catppuccin-mocha-mauve-cursors";
home.sessionVariables.XCURSOR_SIZE = "32";
```

### 5. Configure Niri in niri.nix

```kdl
cursor {
  xcursor-theme "catppuccin-mocha-mauve-cursors"
  xcursor-size 32

  hide-when-typing
}
```

## Key Points
- Use `just build <flavor> <accent>` for catppuccin cursors
- Flavor names: `latte`, `frappe`, `macchiato`, `mocha`
- Accent names: `blue`, `dark`, `flamingo`, `green`, `lavender`, `light`, `maroon`, `mauve`, `peach`, `pink`, `red`, `rosewater`, `sapphire`, `sky`, `teal`, `yellow`
- Output directory name uses kebab-case: `catppuccin-mocha-mauve-cursors` (NOT camelCase)
- Rebuild with `sudo nixos-rebuild switch --flake .#`
- Full logout/login may be needed for environment changes to take effect

## Available Scalable Cursor Themes in nixpkgs
- catppuccin-cursors (based on Volantes) — must build custom variants
- bibata-cursors (Material based) — fixed size, doesn't scale