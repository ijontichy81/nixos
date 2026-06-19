# Horizon Configuration

A simplified shell based on caelestia shell, focusing on essential features while maintaining the border-sidebar connection.

## Features

### Core Elements
- **Sidebar** - Connected to the border for seamless integration
- **Workspace Indicator** - Shows 5 visible workspaces with active indicators
- **Active Window** - Displays current window title
- **System Tray** - Application tray support
- **Clock and Date** - Time and date display

### Status Indicators
- **Network Status** - Network connectivity indicator
- **WiFi** - Wireless network status
- **Bluetooth** - Bluetooth connection status
- **Battery** - Battery level and charging status
- **KB Layout** - Keyboard layout indicator

### Quick Toggles
- **WiFi** - Toggle wireless connectivity
- **Bluetooth** - Toggle Bluetooth
- **Microphone** - Toggle microphone
- **Settings** - Access system settings
- **Game Mode** - Toggle game mode
- **Do Not Disturb** - Toggle DND mode
- **VPN** - VPN connection management

### Utilities
- **Notification History** - Notification management with 5-second default timeout
- **Clipboard Support** - Integrated with vicinae for clipboard history
- **Network Manager Plugin** - Network connection management

### Security
- **Lock Screen** - Fingerprint authentication with 3 attempt limit
- **Power Controls** - Shutdown, reboot, logout, hibernate

## Configuration Details

### Border + Sidebar Connection
- **Border Thickness**: 10px
- **Border Rounding**: 25px
- **Border Smoothing**: 20px
- **Sidebar Drag Threshold**: 80px

### Bar Layout
```
[Logo] [Workspaces] [Active Window] [System Tray] [Clock] [Status Icons] [Power]
```

### Status Icons
All status indicators are shown by default and can be toggled individually.

## Integration

### App Launcher
Uses **vicinae** for application launching (already configured in the system).

### Lock Screen
Uses caelestia's lock screen implementation with fingerprint authentication.

## Customization

### To modify the border appearance:
```nix
border = {
  thickness = 10;  # Adjust thickness
  rounding = 25;   # Adjust rounding
  smoothing = 20;  # Adjust smoothing
};
```

### To modify sidebar behavior:
```nix
sidebar = {
  enabled = true;
  dragThreshold = 80;  # Adjust drag threshold
};
```

### To add/remove status indicators:
```nix
status = {
  showNetwork = true;
  showWifi = true;
  showBluetooth = true;  # Set to false to disable
  showBattery = true;
  showLockStatus = true;
  showKbLayout = true;   # Set to false to disable
};
```

## Building and Testing

To apply the configuration:
```bash
sudo nixos-rebuild switch --flake .#nixos
```

To verify the configuration:
```bash
nixos-rebuild check --flake .#nixos
```
