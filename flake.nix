{
  description = "flake for t480s";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      specialArgs = { inherit inputs; };
      forAllSystems =
        body: lib.genAttrs lib.systems.flakeExposed (system: body nixpkgs.legacyPackages.${system});
    in
    {
      nixosConfigurations = {
        t480s = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./common
            ./t480s
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sreehari = import ./home;
            }
          ];
        };
      };
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
