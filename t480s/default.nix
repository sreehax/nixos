{ config, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  # Boot
  boot = {
    # use grub because I have SeaBIOS for now...
    loader.grub.enable = true;
    loader.grub.device = "/dev/nvme0n1";
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    plymouth = {
      enable = true;
    };
    # Silent boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  # Networking
  networking.hostName = "t480s";
  networking.networkmanager = {
    enable = true;
    #wifi.backend = "iwd";
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Services
  systemd.services.NetworkManager-wait-online.enable = false;
  services = {
    fwupd.enable = true;
    # PipeWire Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Graphical Settings
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    xserver = {
      enable = true;
      xkb.variant = "dvorak";
    };
    gvfs.enable = true;
  };

  # User Account Setup
  users.groups.plugdev = { };
  users.users.sydney = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "plugdev"
    ];
    shell = pkgs.zsh;
    description = "Sydney Sreedev";
  };

  # System Packages and Fonts
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
    pciutils
    usbutils
    sbctl
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.blex-mono
    noto-fonts-cjk-sans
    noto-fonts-emoji
    ibm-plex
  ];

  # Program Settings
  programs.dconf.enable = true;

  # Misc
  security.rtkit.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      ocl-icd
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  # DO NOT CHANGE
  system.stateVersion = "24.05";
}
