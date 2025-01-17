{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  # Localization
  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "dvorak";

  # Basic System Packages
  environment.systemPackages = with pkgs; [
    neovim
    gptfdisk
    exfatprogs
    man-pages
    man-pages-posix
    lz4
  ];

  # Program Settings
  programs.zsh.enable = true;
  programs.git.enable = true;

  # Nix Settings
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.lix;
    registry = {
      n.flake = inputs.nixpkgs;
    };
    channel.enable = false;
    #settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
    nixPath = [ "nixpkgs=${config.nix.registry.nixpkgs.to.path}" ];
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.auto-optimise-store = true;
  };
  #environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  # Misc Settings
  security.sudo.wheelNeedsPassword = false;
  documentation.dev.enable = true;
}
