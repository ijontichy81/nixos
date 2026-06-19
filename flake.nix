{
  description = "NixOS Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixvim, niri, hyprland, caelestia-shell, vicinae, stylix, ... }: {
    nixosConfigurations.nvidia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        stylix.nixosModules.stylix
        ({ pkgs, ... }: {
          stylix = {
            enable = true;
            enableReleaseChecks = false;
            autoEnable = false;
            image = ./assets/pink.jpg;
            polarity = "dark";
            icons = {
              enable = true;
              dark = "Papirus-Dark";
            };
            fonts = {
              monospace = {
                package = pkgs.nerd-fonts.fira-code;
                name = "FiraCode Nerd Font";
              };
              sansSerif = {
                package = pkgs.nerd-fonts.fira-code;
                name = "FiraCode Nerd Font";
              };
              serif = {
                package = pkgs.noto-fonts;
                name = "Noto Serif";
              };
              sizes = {
                applications = 12;
                desktop = 11;
                popups = 12;
                terminal = 12;
              };
            };
            targets = {
              qt.enable = true;
            };
          };
        })
        inputs.agenix.nixosModules.age
        ./hosts/nvidia/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.marco= import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [
            nixvim.homeModules.default
            niri.homeModules.niri
            vicinae.homeManagerModules.default
            { stylix.enableReleaseChecks = false; }
          ];
        }
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            niri.overlays.niri
            (self: super: {
              brave = super.brave.override {
                commandLineArgs = [ "--ozone-platform=wayland" ];
              };
            })
          ];
        })
        ({ pkgs, ... }: {
          environment.systemPackages = [
            niri.packages.x86_64-linux.niri-unstable
            pkgs.yt-dlp
            (pkgs.callPackage ./catppuccin-mocha-green.nix {})
          ];
        })
        ({ pkgs, ... }: {
          home-manager.users.marco.xdg.dataFile."icons/catppuccin-mocha-green-cursors".source = "${pkgs.callPackage ./catppuccin-mocha-green.nix {}}/share/icons/catppuccin-mocha-green-cursors";
        })
      ];
    };

    nixosConfigurations.amd = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        stylix.nixosModules.stylix
        ({ pkgs, ... }: {
          stylix = {
            enable = true;
            enableReleaseChecks = false;
            autoEnable = false;
            image = ./assets/pink.jpg;
            polarity = "dark";
            icons = {
              enable = true;
              dark = "Papirus-Dark";
            };
            fonts = {
              monospace = {
                package = pkgs.nerd-fonts.fira-code;
                name = "FiraCode Nerd Font";
              };
              sansSerif = {
                package = pkgs.nerd-fonts.fira-code;
                name = "FiraCode Nerd Font";
              };
              serif = {
                package = pkgs.noto-fonts;
                name = "Noto Serif";
              };
              sizes = {
                applications = 12;
                desktop = 11;
                popups = 12;
                terminal = 12;
              };
            };
            targets = {
              qt.enable = true;
            };
          };
        })
        ./hosts/amd/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.marco= import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [
            nixvim.homeModules.default
            niri.homeModules.niri
            hyprland.homeManagerModules.default
            caelestia-shell.homeManagerModules.default
            vicinae.homeManagerModules.default
            { stylix.enableReleaseChecks = false; }
          ];
        }
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            niri.overlays.niri
            hyprland.overlays.hyprland-packages
            (self: super: {
              brave = super.brave.override {
                commandLineArgs = [ "--ozone-platform=wayland" ];
              };
            })
          ];
        })
        ({ pkgs, ... }: {
          environment.systemPackages = [
            niri.packages.x86_64-linux.niri-unstable
            niri.packages.x86_64-linux.xwayland-satellite-unstable
            pkgs.hyprland
            pkgs.yt-dlp
            (pkgs.callPackage ./catppuccin-mocha-green.nix {})
          ];
        })
        ({ pkgs, ... }: {
          home-manager.users.marco.xdg.dataFile."icons/catppuccin-mocha-green-cursors".source = "${pkgs.callPackage ./catppuccin-mocha-green.nix {}}/share/icons/catppuccin-mocha-green-cursors";
        })
      ];
    };
  };
}