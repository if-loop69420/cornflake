{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    wazuhPkgs.url = "github:V3ntus/nixpkgs/wazuh-agent";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, nixpkgs, home-manager, niri, lix-module, wazuhPkgs,... }@inputs: 
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.bonkingOnNix = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [ 
        {nixpkgs.overlays = [ (_: _: { inherit (import wazuhPkgs { }) wazuh; }) ]; }
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
  };
}
