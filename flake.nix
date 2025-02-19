{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
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
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    site = {
      url = "github:sreehax/site";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    frostium-site = {
      url = "git+ssh://git@github.com/frostium-project/website";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
            ./home
          ];

        };
        riptide = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            inputs.lanzaboote.nixosModules.lanzaboote
            ./common
            ./riptide
            ./home
          ];
        };
        lux = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            inputs.agenix.nixosModules.default
            inputs.simple-nixos-mailserver.nixosModule
            ./common
            ./lux
            ./secrets
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
        modules = [ ./home/mbp ];
      };
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
