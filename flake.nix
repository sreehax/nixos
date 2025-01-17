{
  description = "flake for t480s";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ancient-nixpkgs.url = "github:nixos/nixpkgs/09704d31f17bb6eb2de763ac31ec3624b811f57c";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      specialArgs = { inherit inputs; };
      forAllSystems =
        body: lib.genAttrs lib.systems.flakeExposed (system: body nixpkgs.legacyPackages.${system});
      overlays = [
        (final: prev: {
          zigpkgs = inputs.zig-overlay.packages.${prev.system};
          ancient = inputs.ancient-nixpkgs.legacyPackages.${prev.system};
        })
      ];
    in
    {
      nixosConfigurations = {
        t480s = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./common
            ./t480s
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sreehari = import ./home;
            }
          ];

        };
        riptide = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            inputs.lanzaboote.nixosModules.lanzaboote
            ./common
            ./riptide
            ./riptide/matlab.nix
          ];
        };
      };
      # macOS home-manager
      homeConfigurations."user" = inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = specialArgs;
        pkgs = import nixpkgs {
          # is there somewhere else to define the system??
          system = "aarch64-darwin";
          inherit overlays;
        };
        modules = [ ./mbp ];
      };
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
