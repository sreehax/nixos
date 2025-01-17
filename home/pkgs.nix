{ config, pkgs, ... }:
{
  home.username = "sydney";
  home.homeDirectory = "/home/sydney";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
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

  programs.home-manager.enable = true;
}
