{
  description = "flake for riptide";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    lanzaboote = {
      url = github:nix-community/lanzaboote;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, home-manager, ...}: {
    nixosConfigurations = {
      riptide = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  lanzaboote.nixosModules.lanzaboote
	  ./riptide/configuration.nix
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.sreehari = import ./home.nix;
	  }
	];
      };
    };
  };
}
