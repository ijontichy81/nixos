{
  description = "NixOS Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixvim, niri, noctalia, nix-colors, vicinae, ... }: {
    nixosConfigurations.nvidia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nvidia/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.marco= import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [
            nixvim.homeModules.nixvim
            niri.homeModules.niri
            noctalia.homeModules.default
            nix-colors.homeManagerModules.default
	    vicinae.homeManagerModules.default
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
          environment.systemPackages = [ niri.packages.x86_64-linux.niri-unstable (pkgs.callPackage ./catppuccin-mocha-green.nix {}) ];
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
        ./hosts/amd/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.marco= import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [
            nixvim.homeModules.nixvim
            niri.homeModules.niri
            noctalia.homeModules.default
            nix-colors.homeManagerModules.default
	    vicinae.homeManagerModules.default
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
          environment.systemPackages = [ niri.packages.x86_64-linux.niri-unstable (pkgs.callPackage ./catppuccin-mocha-green.nix {}) ];
        })
        ({ pkgs, ... }: {
          home-manager.users.marco.xdg.dataFile."icons/catppuccin-mocha-green-cursors".source = "${pkgs.callPackage ./catppuccin-mocha-green.nix {}}/share/icons/catppuccin-mocha-green-cursors";
        })
      ];
    };
  };
}
