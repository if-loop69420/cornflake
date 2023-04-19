{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    hyprland.url = github:hyprwm/Hyprland;
    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "qtwebkit-5.212.0-alpha4"
        ];
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.bonkingOnNix = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./bonkingOnNix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.users.jeremy = {
              imports = [
                hyprland.homeManagerModules.default
                ./bonkingOnNix/home/home.nix
              ];
            };
          }  
        ];
      };
  };
}
