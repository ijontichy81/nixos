# GTK Icon Theme in NixOS + Niri (Launched from TTY, No Display Manager)

## Context & Why This Is Hard

This guide solves a very specific problem: you're running NixOS with Home Manager, using **niri** as your Wayland compositor, launching it directly from TTY1 (no GNOME, no SDDM, no GDM, nothing). You want Nautilus (and other GTK4 apps) to use a custom icon theme like Papirus-Dark.

The reason this is painful is a chain of gotchas:

1. **`environment.sessionVariables` and `home.sessionVariables` are NOT sourced** when you launch from TTY directly. They only apply to login shells or PAM sessions managed by a display manager.
2. **`gtk.enable = true` in Home Manager** silently injects a `dconfSettings` activation step that tries to write to dconf via DBus — which fails at boot time because there's no user DBus session running yet. This breaks the entire Home Manager activation.
3. **GTK4 apps like Nautilus ignore `gtk-3.0/settings.ini`** entirely. They use gsettings/dconf to read the icon theme.
4. **`gsettings-desktop-schemas` as a system package doesn't work** on NixOS the way you'd expect. There are open upstream issues. Don't try that path.
5. **Hardcoding nix store paths** (e.g. for `XDG_DATA_DIRS` in niri's environment block) breaks silently after any package update because the hash in the path changes.
6. **GTK4 ignores `GTK_ICON_THEME`** if gsettings returns a value (even a wrong/empty one). gsettings takes priority.

The correct solution is: enable dconf at the system level, write the icon theme preference directly to the dconf database once your session is running, and wire that up as a niri startup command.

---

## Prerequisites

- NixOS with flakes enabled
- Home Manager (as a NixOS module, i.e. `home-manager.users.<name>`)
- Niri launched from TTY (e.g. `exec niri` in `~/.config/fish/config.fish` on TTY1)
- Fish as your shell (or adapt the fish-specific bits to bash/zsh)
- The icon theme package available in nixpkgs (this guide uses `papirus-icon-theme`)

---

## Step 1: Enable dconf at the System Level

In your `configuration.nix`, add:

```nix
programs.dconf.enable = true;
```

This is the **NixOS system-level option** (not the Home Manager one). It sets up the dconf infrastructure correctly, including the DBus service activation, so that `dconf write` works from within a running user session.

Also make sure `papirus-icon-theme` is in your system packages (or home packages — either works as long as it ends up in `XDG_DATA_DIRS`):

```nix
environment.systemPackages = with pkgs; [
  papirus-icon-theme
  # ... rest of your packages
];
```

Do **not** add `gsettings-desktop-schemas` manually — NixOS manages that through its own mechanisms and manually adding it causes issues.

---

## Step 2: Write GTK Config Files Without Using `gtk.enable`

Do **not** use `gtk.enable = true` in Home Manager. It hooks into dconf activation which fails at boot (no DBus session available when `home-manager-<user>.service` runs).

Instead, write the config files manually. Create a module (e.g. `home/modules/mygtk.nix`) like this:

```nix
{ config, pkgs, lib, ... }:

let
  cfg = config.mygtk;
  themePackage = pkgs.catppuccin-gtk.override {
    variant = cfg.theme;
    accents = [ cfg.accent ];
    size = "standard";
  };
  themeName = "catppuccin-${cfg.theme}-${cfg.accent}-standard";
in
{
  options.mygtk = {
    enable = lib.mkEnableOption "Enable GTK theming";

    theme = lib.mkOption {
      type = lib.types.enum [ "latte" "frappe" "macchiato" "mocha" ];
      default = "macchiato";
      description = "Catppuccin flavor";
    };

    accent = lib.mkOption {
      type = lib.types.enum [ "blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow" ];
      default = "green";
      description = "Catppuccin accent color";
    };

    iconTheme = lib.mkOption {
      type = lib.types.enum [ "Papirus-Dark" "Papirus-Light" "Adwaita" "Qogir-dark" "Qogir" ];
      default = "Papirus-Dark";
      description = "Icon theme name";
    };
  };

  config = lib.mkIf cfg.enable {
    # GTK3 settings (for GTK3 apps)
    xdg.configFile."gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${cfg.iconTheme}
      gtk-font-name=FiraCode Nerd Font 11
      gtk-application-prefer-dark-theme=1
    '';

    # GTK4 settings (for GTK4 apps like Nautilus)
    # Note: GTK4 reads this file but ultimately defers to gsettings/dconf
    # for icon-theme. The dconf write in niri startup handles that.
    xdg.configFile."gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-icon-theme-name=${cfg.iconTheme}
      gtk-application-prefer-dark-theme=1
    '';

    # GTK4 theme CSS files (for the visual theme, not the icon theme)
    xdg.configFile."gtk-4.0/gtk.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk.css";
    xdg.configFile."gtk-4.0/gtk-dark.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk-dark.css";
    xdg.configFile."gtk-4.0/assets".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/assets";

    # Make icon theme and GTK theme packages available
    home.packages = [ pkgs.papirus-icon-theme themePackage ];

    home.sessionVariables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
    };
  };
}
```

Import this in your `home.nix`:

```nix
imports = [
  ./home/modules/mygtk.nix
  # ... other imports
];

mygtk = {
  enable = true;
  theme = "macchiato";
  accent = "green";
  iconTheme = "Papirus-Dark";
};
```

---

## Step 3: Do NOT Set XDG_DATA_DIRS Manually in Niri

In your niri config (`niri/config.kdl`), do **not** hardcode `XDG_DATA_DIRS`. The nix-generated value already contains the correct paths to all icon themes. Overriding it breaks things silently whenever a package hash changes.

Your niri `environment` block should look like this:

```kdl
environment {
  GTK_ICON_THEME "Papirus-Dark"
  XCURSOR_THEME "catppuccin-mocha-green-cursors"
  XCURSOR_SIZE "32"
}
```

`GTK_ICON_THEME` is a hint but GTK4 will still prefer gsettings — the next step handles that.

---

## Step 4: Write the Icon Theme to dconf at Session Startup

Add this to your niri `spawn-at-startup` lines in `config.kdl`:

```kdl
spawn-at-startup "dconf" "write" "/org/gnome/desktop/interface/icon-theme" "'Papirus-Dark'"
```

**Important:** The inner single quotes around `Papirus-Dark` are required. dconf expects a GVariant string, which is represented as `'value'` (with single quotes inside the outer shell double quotes).

This works because:
- By the time niri's `spawn-at-startup` runs, your user DBus session is live
- `dconf write` bypasses gsettings and writes directly to `~/.config/dconf/user`
- The value persists across reboots (it's stored in the binary dconf db)
- Nautilus and all other GTK4 apps read this key at startup

The `spawn-at-startup` is kept as insurance — if anything ever wipes `~/.config/dconf/user` (e.g. a stray `rm -rf` or certain Home Manager operations), it'll be rewritten automatically on next login.

---

## Step 5: Rebuild and Verify

```bash
sudo nixos-rebuild switch --flake .
```

Then reboot (or re-login to your niri session). To verify it worked:

```fish
# Should print 'Papirus-Dark'
dconf read /org/gnome/desktop/interface/icon-theme
```

Launch Nautilus — it should now show Papirus-Dark icons.

---

## Changing the Icon Theme Later

1. Update the `iconTheme` value in your `mygtk` config in `home.nix`
2. Update the `GTK_ICON_THEME` value in your niri `environment` block
3. Update the `dconf write` value in your niri `spawn-at-startup`
4. Make sure the new icon theme package is in `home.packages` or `environment.systemPackages`
5. Rebuild and reboot

---

## Applying This to a Fresh NixOS Setup

Checklist:

- [ ] `programs.dconf.enable = true` in `configuration.nix`
- [ ] Icon theme package in `environment.systemPackages` or `home.packages`
- [ ] No `gtk.enable = true` in Home Manager (use manual `xdg.configFile` instead)
- [ ] No `dconf.settings` in Home Manager (requires live DBus, fails at boot)
- [ ] No hardcoded nix store paths in niri's `XDG_DATA_DIRS`
- [ ] `dconf write` in niri's `spawn-at-startup` with correct GVariant quoting
- [ ] Rebuild + reboot (a `home-manager switch` alone is not enough)

---

## Debugging Reference

If icons still don't appear after following this guide, use these commands from within your running niri session:

```fish
# Confirm dconf has the right value
dconf read /org/gnome/desktop/interface/icon-theme

# Confirm the icon theme is findable in XDG_DATA_DIRS
ls /run/current-system/sw/share/icons/ | grep -i papirus

# Check what XDG_DATA_DIRS looks like in your session
echo $XDG_DATA_DIRS

# Launch nautilus with GTK icon theme debug output
GTK_DEBUG=icontheme nautilus 2>&1 | grep -i "papirus\|look for\|scanning" | head -30

# Write dconf value manually if spawn-at-startup hasn't run yet
dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-Dark'"
```

The `GTK_DEBUG=icontheme` output will show exactly which directories GTK is scanning. If you see `Papirus-Dark` in the scan list, the theme is being found. If you only see `hicolor`, the dconf value isn't being read correctly.
