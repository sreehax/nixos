{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "user";
  home.homeDirectory = "/Users/user";

  home.packages = with pkgs; [
    # development
    #zig
    tree
    flashrom
    zigpkgs.master-2025-01-03
    bun
    acpica-tools
    ancient.neovim
    nodejs
    nil
    lua-language-server
    macfuse-stubs
    typst
    typst-lsp

    # fonts
    nerd-fonts.fira-code

    # tools
    tt
    neofetch
    fastfetch
    cmatrix
    ripgrep
    mp4v2
    kitty
    gimp
    graphviz
    (python3.withPackages (
      ppkgs: with ppkgs; [
        numpy
        pwntools
        pandas
        pydot
        ipython
        #z3
        torch-bin
        torchvision-bin
        matplotlib
        flask
        flask-cors
        neo4j
        bcrypt
      ]
    ))
    p7zip
    age
    verilog
    gtkwave
    mtr
    gprolog
    b3sum
    android-tools
    exiftool
    meson
    minisign
    idevicerestore
    libimobiledevice
    bat
    qemu
  ];

  home.file = { };
  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # same flake registry stuff
  nix.registry = {
    n.flake = inputs.nixpkgs;
  };

  # DO NOT CHANGE
  home.stateVersion = "23.11";
}
