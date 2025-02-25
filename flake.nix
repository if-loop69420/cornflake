{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master"; # or release-whatever
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, niri, lix-module, nixos-hardware,... }@inputs: 
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.bonkingOnNix = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [ 
          ./bonkingOnNix
          lix-module.nixosModules.default
          niri.nixosModules.niri
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.users.jeremy = {
              imports = [
                ./home/home.nix
              ];
            };
          }  
        ];
      };
      nixosConfigurations.frame-wok = lib.nixosSystem {
                inherit system;
        specialArgs = {inherit inputs;};
        modules = [ 
          ./frame-wok
          nixos-hardware.nixosModules.framework-13-7040-amd
          lix-module.nixosModules.default
          niri.nixosModules.niri
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.users.jeremy = {
              imports = [
                ./jeremy/home/home.nix
              ];
            };
          }  
        ];
      };
    };
}
