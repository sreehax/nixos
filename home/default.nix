{ inputs, config, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  config.nixpkgs.overlays = [
    inputs.nix-matlab.overlay
  ];

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.sydney = ./pkgs.nix;
    backupFileExtension = "backup";
  };
}
