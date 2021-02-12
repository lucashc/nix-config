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
  programs.home-manager.enable = true;
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
    # Office
    libreoffice
    unstable.zoom-us
    unstable.teams
    texstudio
    # Media players
    mpv
    vlc
    unstable.spotify
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
  ])
  # KDE Applications
  ++ (with pkgs.kdeApplications; with pkgs; [
    digikam
    krita
    okular
    ark
    filelight
    kate
    kcalc
  ]);

  programs.firefox.enable = true;

  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs)
        scheme-medium
	      collection-fontsrecommended
	      algorithms;
    };
  };



  programs.vscode.enable = true;
  programs.git = {
    enable = true;
    userName = "Lucas Crijns";
    userEmail = "lucascrijns@gmail.com";
  };
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
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
