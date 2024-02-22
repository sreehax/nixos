# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # Boot
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "bcachefs" ];
  };

  # Networking
  networking = {
    useDHCP = false;
    hostName = "router";
    bridges = {
      br0 = {
        interfaces = [ "enp3s0f0" "enp3s0f1" ];
      };
    };
    interfaces = {
      # WAN interface uses dhcp
      enp4s0f0.useDHCP = true;
      br0 = {
        ipv4.addresses = [
          { address = "10.69.0.1"; prefixLength = 16; }
        ];
      };
    };
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = import ./nftables.nix;
    };
    wireguard.interfaces = {
      wg0 = import ./wireguard.nix;
    };
  };
  
  # Services
  services = {
    openssh.enable = true;
    openssh.settings.PasswordAuthentication = false;
    openssh.settings.X11Forwarding = true;
    kea.dhcp4 = {
      enable = true;
      settings = import ./kea.nix;
    };
    unbound = {
      enable = true;
      settings = import ./unbound.nix;
    };
    samba-wsdd = {
      enable = true;
      interface = "br0";
    };
    samba = import ./samba.nix;
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    fastfetch
    dig
    tcpdump
    wireguard-tools
  ];

  # User Account Setup
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    description = "Router User";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwx/H7u/Ni7W0AM+U8crN3EpV/0IBRvjtkahUEwjp/9 user@balls.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYI8038ZK8GFZmX2j8gwe5OR70+gP2PZFz79TCFvZQH sreehari@riptide"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZia9DRTRY7GgX5/3WY8HkHolO0yHG7i+jwIZ8bg9eZ sreehari@riptide"
    ];
  };
  users.users.guest = {
    isSystemUser = true;
    shell = "${pkgs.shadow}/bin/nologin";
    description = "Guest User";
    group = "guest";
  };
  users.groups.guest = { members = [ "guest" ]; };

  # Misc
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      intel-compute-runtime
      ocl-icd
    ];
  };

  # DO NOT CHANGE THIS
  system.stateVersion = "24.05"; # Did you read the comment?
}

