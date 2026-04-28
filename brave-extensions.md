# Managing Brave Extensions in NixOS/Home Manager

This document explains how to manage Brave browser extensions using Home Manager in your NixOS configuration.

## Overview

In this setup, Brave extensions are managed declaratively through Home Manager. This means:
- Extensions are specified in your configuration
- Changes are applied when you rebuild your system
- The setup is reproducible and version-controlled
- No manual installation through the browser UI is needed (and such changes would be overwritten on rebuild)

## Configuration Location

Brave browser configuration is located in:
```
/home/marco/nixos/nixos/home/modules/brave.nix
```

## How Extensions Are Specified

Extensions are identified by their Chrome Web Store IDs. In your `brave.nix` file, you'll see:

```nix
programs.brave = {
  enable = true;
  extensions = [
    "extension-id-here"  # Extension description
  ];
};
```

## Finding Extension IDs

To find the ID for any extension:

1. Go to the Chrome Web Store: https://chrome.google.com/webstore
2. Search for the extension you want
3. Click on the extension to open its detail page
4. Look at the URL in your browser's address bar
5. The URL will look like: 
   `https://chrome.google.com/webstore/detail/extension-name/EXTENSION-ID`
6. Copy the `EXTENSION-ID` part (usually a 32-character string)

Example:
- URL: `https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm`
- Extension ID: `cjpalhdlnbpafiamejdnhcphjbkeiagm`

## Adding or Removing Extensions

1. Edit the file: `/home/marco/nixos/nixos/home/modules/brave.nix`
2. Modify the `extensions` list:
   - To add: Include the extension ID in the list
   - To remove: Delete the extension ID from the list
3. Save the file

## Applying Changes

Since you use the flake-based approach with `nixos-rebuild switch`:

```bash
sudo nixos-rebuild switch
```

This command will:
1. Rebuild your NixOS system configuration
2. Apply your Home Manager configuration (including Brave settings)
3. Install/remove the specified Brave extensions
4. Set Brave as your default browser

## Verifying Your Configuration

After rebuilding, you can verify:

1. **Brave is installed:**
   ```bash
   which brave-browser
   ```

2. **Default browser is set correctly:**
   ```bash
   xdg-settings get default-web-browser
   # Should return: brave-browser.desktop
   ```

3. **Extensions are installed:**
   - Open Brave browser
   - Visit: `brave://extensions`
   - Your specified extensions should appear in the list

4. **Session variable is set:**
   ```bash
   echo $DEFAULT_BROWSER
   # Should show path to brave binary
   ```

## Troubleshooting

### Extensions Not Appearing
1. Run `sudo nixos-rebuild switch` again to ensure changes applied
2. Check that the extension ID is correct (no typos)
3. Verify the extension is available in the Chrome Web Store
4. Check Brave extensions page (`brave://extensions`) for any error messages

### Default Browser Not Changing
1. Run `sudo nixos-rebuild switch` again
2. Log out and back in (or restart your session)
3. Try running: `xdg-mime default brave-browser.desktop x-scheme-handler/http`
4. Then: `xdg-mime default brave-browser.desktop x-scheme-handler/https`

### Conflicts with Manual Installation
If you manually install extensions through Brave's UI:
- Those changes may be overwritten when you run `nixos-rebuild switch`
- For persistent changes, always modify your `home/modules/brave.nix` file
- Consider removing manually installed extensions before rebuilding to avoid conflicts

## Recommended Starting Extensions

Here are some popular privacy-focused extensions with their IDs:

- **uBlock Origin**: `cjpalhdlnbpafiamejdnhcphjbkeiagm`
- **Privacy Badger**: `nngceckbapebfimnlniiiahkandfilfh`
- **Bitwarden**: `ejbalbakoplchlghecdalmeeeajnimhm`
- **HTTPS Everywhere**: `gcbommkclmclsdpchicofobncdkkkeem`
- **Dark Reader**: `eimadpbcbfnmbkopoojfekhnkhdbieeh`

To use these, simply uncomment the corresponding lines in your `brave.nix` extensions list.

## Maintenance Tips

1. **Periodically review** your extension list - remove extensions you no longer use
2. **Keep extensions updated** - they update automatically through the Chrome Web Store
3. **Backup your configuration** - your `home/modules/brave.nix` file is part of your version-controlled NixOS config
4. **Test new extensions** one at a time to ensure they don't cause conflicts

## Alternative Approaches (Not Recommended for This Setup)

While it's possible to manage extensions through:
- System-wide NixOS configuration (`/etc/nixos/configuration.nix`)
- Browser policies
- Manual installation via Brave UI

These approaches are less ideal because:
- They don't integrate with your declarative Home Manager workflow
- They may not persist across system rebuilds
- They're harder to version control and share
- Manual UI changes will be overwritten when you rebuild

Sticking to the Home Manager approach in `home/modules/brave.nix` ensures consistency with the rest of your NixOS configuration.