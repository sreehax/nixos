{
  description = "flake for riptide";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    lanzaboote = {
      url = github:nix-community/lanzaboote;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kde2nix = {
      url = github:nix-community/kde2nix;
    };
  };

  outputs = { self, nixpkgs, lanzaboote, kde2nix, ...}: let
    specialArgs = { inherit nixpkgs lanzaboote kde2nix; };
  in {
    nixosConfigurations = {
      riptide = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	inherit specialArgs;
	modules = [
	  lanzaboote.nixosModules.lanzaboote
	  kde2nix.nixosModules.plasma6
	  ./common
	  ./riptide
	];
      };

      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	inherit specialArgs;
	modules = [
	  lanzaboote.nixosModules.lanzaboote
	  kde2nix.nixosModules.plasma6
	  ./common
	  ./thinkpad
	];
      };

      router = nixpkgs.lib.nixosSystem {
      	system = "x86_64-linux";
	inherit specialArgs;
	modules = [
	  ./common
	  ./router
	];
      };
    };
  };
}
