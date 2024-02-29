{ config, lib, pkgs, ... }:

{
  # Import Hardware Configuration
  imports =
    [ ./hardware.nix ];
  
  # Boot
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = lib.mkForce false;
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "bcachefs" ];
    blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # Networking
  networking.hostName = "riptide";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Services
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services = {
    nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "cumslut.ssree.dev" = {
	  locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
	  addSSL = true;
	  enableACME = true;
	};
      };
    };
    hardware.openrgb.enable = true;
    hardware.openrgb.package = pkgs.openrgb-with-all-plugins;
    # PipeWire Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Graphical Settings
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      displayManager.defaultSession = "plasma";
      desktopManager.plasma6.enable = true;

      libinput.enable = true;
      xkb.layout = "us";
      xkb.variant = "dvorak";
    };
    gvfs.enable = true;
    udev.packages = [ pkgs.rtl-sdr ];
    usbmuxd.enable  = true;
    fwupd.enable = true;
    openssh.enable = true;
    openssh.settings.X11Forwarding = true;
  };

  # User Account Setup
  users.groups.plugdev = {};
  users.users.sreehari = {
    isNormalUser = true;
    extraGroups = [ "wheel" "plugdev" ];
    shell = pkgs.zsh;
    description = "Sreehari Sreedev";
  };

  # System Packages and Fonts
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
    rtl-sdr
    pciutils
    usbutils
    sbctl
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "IBMPlexMono" ]; })
    noto-fonts-cjk
    noto-fonts-emoji
    ibm-plex
  ];

  # Program Settings
  programs.dconf.enable = true;

  # Misc
  security.rtkit.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "sreehairy@gmail.com";
  };
  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      ocl-icd
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  # DO NOT CHANGE
  system.stateVersion = "24.05";
}
