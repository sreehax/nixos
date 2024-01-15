{ config, lib, pkgs, ... }:

{
  # Import Hardware Configuration
  imports =
    [
      ./hardware.nix
    ];
  
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
  };

  # Networking
  networking.hostName = "riptide";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Localization
  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "dvorak";

  # Services
  services = {
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
      displayManager.defaultSession = "plasmawayland";
      desktopManager.plasma5.enable = true;

      libinput.enable = true;
      xkb.layout = "us";
      xkb.variant = "dvorak";
    };
    gvfs.enable = true;
    udev.packages = [ pkgs.rtl-sdr ];
  };

  # System Packages and Fonts
  environment.systemPackages = with pkgs; [
    neovim
    sddm-kcm
    gptfdisk
    exfatprogs
    man-pages
    man-pages-posix
    lz4
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

  # User Account Setup
  users.groups.plugdev = {};
  users.users.sreehari = {
    isNormalUser = true;
    extraGroups = [ "wheel" "plugdev" ];
    shell = pkgs.zsh;
    description = "Sreehari Sreedev";
  };

  # Program Settings
  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  # Misc
  security.sudo.wheelNeedsPassword = false;
  security.rtkit.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  documentation.dev.enable = true;
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
