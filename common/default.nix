{ nixpkgs }:
{ pkgs, lib, ... }: {
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
    registry = {
      n.flake = nixpkgs;
    };
    channel.enable = false;
    settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

  # Misc Settings
  security.sudo.wheelNeedsPassword = false;
  documentation.dev.enable = true;
}
