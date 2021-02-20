# Home configuration
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
    ipython
    jupyter
  ]);
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in
{
  # Home-Manager setup
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # User packages
  home.packages = (with pkgs; [
    # Python
    basicPythonEnv
    # Basic utilities
    fortune
    glxinfo
    pciutils
    zip
    xz
    bzip2
    powertop
    # Office
    libreoffice-fresh
    unstable.zoom-us
    unstable.teams
    texstudio
    # Media players
    mpv
    vlc
    spotify
    # Image manipulation
    imagemagick
    krita
    inkscape
    gimp-with-plugins
    ipe
    # Media
    discord
    signal-desktop
    # Gaming
    steam
    # Web browser
    firefox-esr
  ])
  # GNOME Applications
  ++ (with pkgs.gnome3; with pkgs; [
    eog # Image viewer
    evince # PDF reader
    gnome-tweak-tool

    # Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.clipboard-indicator
  ]);

  # Programs and their config
  programs = {
    # Enable Home-Manager
    home-manager.enable = true;
    # Enable latex
    texlive = {
        enable = true;
        extraPackages = tpkgs: {
        inherit (tpkgs)
            scheme-full;
        };
    };

    # Enable vscode
    vscode.enable = true;

    # Enable git
    git = {
        enable = true;
        userName = "Lucas Crijns";
        userEmail = "lucascrijns@gmail.com";
    };
    
    # Enable gpg
    gpg.enable = true;
  };

  # Services
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
    syncthing = {
      enable = true;
    };
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
