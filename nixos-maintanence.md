content = """# NixOS Flakes: Maintenance Cheat Sheet

Welcome to NixOS with Flakes! Since you are now using a `flake.lock` file as the source of truth for your system state, your maintenance workflow differs slightly from the traditional channel-based approach.

Here are the essential commands to keep your system updated and your `/nix/store` tidy.

---

## 1. Updating the System
In a Flake-based setup, you update the inputs defined in your `flake.nix` before rebuilding.

### Step A: Update the Lock File
This command fetches the latest commits for your inputs (like `nixpkgs`) and updates your `flake.lock`.
```bash
nix flake update
```

### Step B: Apply the Update
After updating the lock file, rebuild and switch to the new configuration.
```bash
sudo nixos-rebuild switch --flake .
```
*(Replace `.` with the path to your configuration directory if you aren't currently in it.)*

---

## 2. Cleaning the System (Garbage Collection)
Nix preserves every version of your system (generations) and every package ever downloaded to allow for easy rollbacks. Over time, this consumes significant disk space.

### The Standard Clean
Deletes packages that are no longer referenced by any generation.
```bash
nix-collect-garbage -d
```

### The Deep Clean
Deletes **all** old system generations and their associated packages. **Warning:** You will not be able to roll back to previous versions after running this.
```bash
sudo nix-collect-garbage -d
```

### Optimizing the Store
Identifies identical files in the Nix store and replaces them with hard links to save space.
```bash
nix-store --optimise
```

---

## 3. Managing Generations
If you want more granular control over what you delete:

### List Generations
View your current system history:
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Delete Older Than X Days
A balanced way to keep recent rollbacks while clearing out the distant past:
```bash
sudo nix-collect-garbage --delete-older-than 14d
```

---

## 4. Automation
To keep your system tidy without manual intervention, add these settings to your `configuration.nix`:

```nix
{
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
```

---

## Summary Table

| Goal | Command |
| :--- | :--- |
| **Update Inputs** | `nix flake update` |
| **Apply Changes** | `sudo nixos-rebuild switch --flake .` |
| **Clean Old Files** | `nix-collect-garbage -d` |
| **Delete History** | `sudo nix-collect-garbage --delete-older-than 14d` |
| **Deduplicate** | `nix-store --optimise` |
"""

with open("nixos-flakes-maintenance.md", "w") as f:
    f.write(content)


```

