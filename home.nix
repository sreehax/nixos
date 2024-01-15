{ pkgs, ... }: {
  home.username = "sreehari";
  home.homeDirectory = "/home/sreehari";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    neofetch
    firefox
    blender
    darktable
    rawtherapee
    mesa-demos
    clinfo
    wayland-utils
    vulkan-tools
  ];
  programs.alacritty = {
    enable = true;
    settings = {
     font = {
        normal = {
      family = "BlexMono Nerd Font";
      style = "Light";
    };
    bold = {
      family = "BlexMono Nerd Font";
      style = "Bold";
    };
    italic = {
      family = "BlexMono Nerd Font";
      style = "Italic";
    };
    bold_italic = {
      family = "BlexMono Nerd Font";
      style = "Bold Italic";
    };
    size = 13;
      };
      colors = {
        primary = {
      background = "0x1e2127";
          foreground = "0xabb2bf";
      bright_foreground = "0xe6efff";
    };
    normal = {
      black = "0x1e2127";
          red = "0xe06c75";
      green = "0x98c379";
      yellow = "0xd19a66";
      blue = "0x61afef";
      magenta = "0xc678dd";
      cyan = "0x56b6c2";
      white = "0x828791";
    };
    bright = {
      black = "0x5c6370";
      red = "0xe06c75";
      green = "0x98c379";
      yellow = "0xd19a66";
      blue = "0x61afef";
      magenta = "0xc678dd";
      cyan = "0x56b6c2";
      white = "0xe6efff";
    };
    dim = {
      black = "0x1e2127";
      red = "0xe06c75";
      green = "0x98c379";
      yellow = "0xd19a66";
      blue = "0x61afef";
      magenta = "0xc678dd";
      cyan = "0x56b6c2";
      white = "0x828791";
    };
      };
    };
  };
  home.stateVersion = "24.05";
}
