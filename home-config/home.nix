{ config, pkgs, ... }:
let
  basicPythonEnv = with pkgs; python3.withPackages (ps: with ps; [
    numpy
    scipy
    cython
    matplotlib
    pandas
    tqdm
    pillow
    imageio
  ]);
in
{
  # Home-Manager setup
  programs.home-manager.enable = true;
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # User packages
  home.packages = with pkgs; [
    # Python
    basicPythonEnv
    # Basic utilities
    htop
    fortune
    killall
    # Office
    libreoffice
    zoom-us
    # Media players
    mpv
    vlc
    spotify
    # Image manipulation
    imagemagick
    krita
    inkscape
    gimp-with-plugins
    # Media
    discord
    signal-desktop
    # Gaming
    steam
  ];
  
  programs.vscode.enable = true;
  programs.git = {
    enable = true;
    userName = "Lucas Crijns";
    userEmail = "lucascrijns@gmail.com";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
