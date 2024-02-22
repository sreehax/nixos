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
    kdePackages.sddm-kcm # sddm-kcm
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
