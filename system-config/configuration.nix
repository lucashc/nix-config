# System configuration

{ config, pkgs, ... }:
let
  # Custom script for running on the nVidia-GPU.
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
  # Load the unstable repository.
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.resumeDevice = "/dev/mapper/enc";
  boot.kernelParams = [
    "resume_offset=1840384" # Calculate on new install
  ];

  # Cleanup tmp at boot.
  boot.cleanTmpDir = true;

  # Enable all firmware.
  hardware.enableAllFirmware = true;

  # Enable bluetooth.
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
  };

  # Enable microcode updates.
  hardware.cpu.intel.updateMicrocode = true;

  # Enable Pulseaudio.
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; 
  };
  
  # Use latest unstable kernel.
  boot.kernelPackages = unstable.linuxPackages_latest;
  
  # Set networking.
  networking.hostName = "Horizon"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "en_GB.UTF-8/UTF-8" "nl_NL.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_TIME = "nl_NL.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
     };
  };
  console.keyMap = "us-acentos";

  # Enable SDDM.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  # Fix Cursor theme.
  services.xserver.displayManager.sddm.extraConfig = ''
  [Theme]
  CursorTheme=breeze_cursors
  '';
  # Enable the Plasma 5 Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
  
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "intl";

  # Enable nvidia drivers.
  # Use the latest versions.
  services.xserver.videoDrivers = [ "nvidiaBeta" ];
  hardware.nvidia = {
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    powerManagement.enable = true;
  };

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  
  # Package options
  nixpkgs.config.allowUnfree = true;

  # Default system packages.
  environment.systemPackages = with pkgs; [
    wget vim
    firefox
    nvidia-offload
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
    ubuntu_font_family
    dejavu_fonts
    source-code-pro
  ];

  # Enable the firewall by default.
  networking.firewall.enable = true;

  # Battery management.
  services.tlp.enable = true;

  # Security settings.
  security = {
    # Enable hardware RNG by using TPM.
    rngd.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

