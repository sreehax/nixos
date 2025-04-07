{ config, pkgs, ... }:
{
  home.username = "sydney";
  home.homeDirectory = "/home/sydney";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    zig
    zls
    zed-editor
    fastfetch
    hyfetch
    firefox
    tmux
    matlab
    matlab-shell
    texlive.combined.scheme-small
    (python3.withPackages (
      ppkgs: with ppkgs; [
        pwntools
        scapy
        pycryptodome
      ]
    ))
    tidal-hifi
    dig
    thunderbird
    eclipses.eclipse-java
    libreoffice-qt6-fresh
    fragments
    vlc
    lean4
    ripgrep
    lua-language-server
    clang-tools
    winetricks
    wineWowPackages.stable
    darktable
    zoom-us
    corefonts
    vistafonts
    scenebuilder
    kicad
    ghostty
    hut
    tor-browser
    gcc
    gnumake
  ];
  fonts.fontconfig.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  programs.alacritty = {
    enable = true;
    settings = import ./alacritty.nix;
  };
  programs.librewolf = {
    enable = true;
    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };

  programs.home-manager.enable = true;
}
