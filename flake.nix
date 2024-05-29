{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, nixpkgs, home-manager, niri, ... }@inputs: 
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
  };
}
