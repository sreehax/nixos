{
  description = "flake for riptide";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    lanzaboote = {
      url = github:nix-community/lanzaboote;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, ...}: let
    specialArgs = { inherit nixpkgs lanzaboote; };
  in {
    nixosConfigurations = {
      riptide = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	inherit specialArgs;
	modules = [
	  lanzaboote.nixosModules.lanzaboote
	  ./common
	  ./riptide
	];
      };

      router = nixpkgs.lib.nixosSystem {
      	system = "x86_64-linux";
	modules = [
	  ./common
	  ./router
	];
      };
    };
  };
}
