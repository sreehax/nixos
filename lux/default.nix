{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./wireguard.nix
    ./vaultwarden.nix
    ./nsd.nix
    ./nginx.nix
    ./mailserver.nix
  ];

  # Boot
  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/vda";
    kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "bcachefs" ];
  };

  # Networking
  networking = {
    hostName = "lux";
    defaultGateway = "104.244.76.1";
    defaultGateway6 = "2605:6400:30::1";
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
    useDHCP = false;
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          {
            address = "104.244.76.122";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2605:6400:30:f9a2::2";
            prefixLength = 48;
          }
        ];
      };
    };
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = builtins.readFile ./nftables.conf;
    };
  };

  # Services
  services = {
    openssh.enable = true;
    openssh.settings.PasswordAuthentication = false;
    bird2 = {
      enable = true;
      config = builtins.readFile ./bird2.conf;
    };
    postgresql = {
      enable = true;
      ensureDatabases = [ "cse412" ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
        host  all      all     127.0.0.1/32   trust
        host    all             all             ::1/128                 trust
      '';
    };
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "me@ssree.dev";

  # System Packages
  environment.systemPackages = with pkgs; [
    dig
    tcpdump
    wireguard-tools
    fastfetch
    tmux
    arch-install-scripts
  ];

  # User Account Setup
  users.users.sydney = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    description = "Sydney Sreedev";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYI8038ZK8GFZmX2j8gwe5OR70+gP2PZFz79TCFvZQH"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwx/H7u/Ni7W0AM+U8crN3EpV/0IBRvjtkahUEwjp/9 Black & White TV"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1WTWlpbr3Nb9L0yHW6IfscQhWgC8p3uZd8w4bojcrL"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBE7hC8CRXjSwVhgAdah7RegsyBisL9BQgEBuHMKrWLAxBKQcST5HrgxaiDyWOZkw+5rDQ5gjn05ge9z+oh/xm0k="
    ];
  };
  nix.settings.trusted-users = [
    "@wheel"
  ];

  # DO NOT CHANGE THIS
  system.stateVersion = "24.05";
}
