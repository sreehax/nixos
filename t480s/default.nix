{ config, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  # Boot
  boot = {
    #loader.grub.enable = true;
    #loader.grub.device = "/dev/nvme0n1";
    #loader.grub.efiSupport = true;
    loader.limine = {
      enable = true;
      biosSupport = true;
      biosDevice = "/dev/nvme0n1";
      efiSupport = true;
      efiInstallAsRemovable = true;
      partitionIndex = 3;
      extraEntries = builtins.readFile ./limine.extra.conf;
      style.interface.resolution = "1920x1080";
      style.wallpapers = [];
    };
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    plymouth = {
      enable = false;
    };
    # Silent boot
    #consoleLogLevel = 0;
    #initrd.verbose = false;
    #initrd.kernelModules = [ "i915" ];
    #kernelParams = [
    #  "quiet"
    #  "splash"
    #  "boot.shell_on_fail"
    #  "loglevel=3"
    #  "rd.systemd.show_status=false"
    #  "rd.udev.log_level=3"
    #  "udev.log_priority=3"
    #];
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
    openssh.enable = true;
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
      wayland.compositor = "kwin";
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
      "libvirtd"
      "wireshark"
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
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # Misc
  security.rtkit.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-ocl
      vpl-gpu-rt
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  # DO NOT CHANGE
  system.stateVersion = "24.05";
}
