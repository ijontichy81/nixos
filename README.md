# NixOS Config

## Rebuild

Rebuild and switch to the new configuration.

**Bash:**
```bash
sudo nixos-rebuild switch --flake .#nixos
```

**Zsh:**
```bash
sudo nixos-rebuild switch --flake '.#nixos'
```

zsh treats `#` as a comment character unless quoted, causing the glob error.

---

## Add Package at Runtime

Install a package to your user profile (persists until removed).

**Bash:**
```bash
nix profile install nixpkgs#htop
```

**Zsh:**
```bash
nix profile install 'nixpkgs#htop'
```

zsh interprets everything after `#` as a comment.

Or run once without installing:

```bash
nix run nixpkgs#htop
```

---

## Update System

Rebuild with the latest nixpkgs.

**Bash:**
```bash
sudo nixos-rebuild switch --flake .#nixos --upgrade
```

**Zsh:**
```bash
sudo nixos-rebuild switch --flake '.#nixos' --upgrade
```

---

## Update Flake

Downloads latest versions of all flake inputs.

```bash
nix flake update
```

Requires rebuild after to apply changes.

---

## List Generations

```bash
sudo nix-env --list-generations -p /nix/var/nix/profiles/system
```

Delete all old generations (keep current and last backup):

```bash
sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system
```

---

## Garbage Collection

Remove old generations and unused packages.

```bash
sudo nix-collect-garbage -d
```

---

## Rollback

Rollback to the previous generation.

**Bash:**
```bash
sudo nixos-rebuild switch --flake .#nixos --rollback
```

**Zsh:**
```bash
sudo nixos-rebuild switch --flake '.#nixos' --rollback
```

---

## Check Current Nixpkgs Version

```bash
nixos-version
```