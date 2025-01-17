{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nix-matlab.overlay
  ];
}
