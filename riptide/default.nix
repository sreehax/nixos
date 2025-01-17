{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware.nix ];

  # Boot
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
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
  networking.hostName = "riptide";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.69.3/24" ];
      privateKeyFile = "/root/wireguard-keys/private";
      listenPort = 51820;
      peers = [
        {
          publicKey = "gDSnymmeuX4a8az4kUHcoltMMHb8mdJCti/TYV62kwA=";
          allowedIPs = [ "192.168.69.0/24" ];
          endpoint = "185.44.83.60:12345";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = false;

  # Services
  systemd.services.NetworkManager-wait-online.enable = false;
  services = {
    openssh.enable = true;
    openssh.openFirewall = true;
    usbmuxd.enable = true;
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
      xkb.layout = "us";
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
      "wireshark"
      "plugdev"
      "adbusers"
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
    matlab
    matlab-shell
    lutris
    ifuse
    libimobiledevice
    idevicerestore
  ];
  fonts.packages = with pkgs; [
    #(nerdfonts.override { fonts = [ "FiraCode" "IBMPlexMono" ]; })
    nerd-fonts.fira-code
    nerd-fonts.blex-mono
    noto-fonts-cjk-sans
    noto-fonts-emoji
    ibm-plex
  ];

  # Program Settings
  programs.adb.enable = true;
  programs.nix-ld.enable = true;
  programs.dconf.enable = true;
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
  programs.virt-manager.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.libvirtd.enable = true;

  # Misc
  security.rtkit.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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
