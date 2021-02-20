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

  # Boot options.
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };
    
    resumeDevice = "/dev/mapper/enc";
    kernelParams = [
      "resume_offset=1840384" # Calculate on new install
    ];

    # Cleanup tmp at boot.
    cleanTmpDir = true;

    # Use latest unstable kernel.
    kernelPackages = unstable.linuxPackages_latest;
  };

  # Hardware options.
  hardware = {
    # Enable all firmware.
    enableAllFirmware = true;

    # Enable bluetooth.
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };

    # Enable microcode updates.
    cpu.intel.updateMicrocode = true;

    # Enable Pulseaudio.
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull; 
    };

    # Enable nvidia drivers.
    nvidia = {
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      powerManagement.enable = true;
    };

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  
  # Set networking.
  networking = {
    hostName = "Horizon";
    networkmanager.enable = true;
    firewall.enable = true;

  };

  # Select internationalisation properties.
  time.timeZone = "Europe/Amsterdam";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "en_GB.UTF-8/UTF-8" "nl_NL.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_TIME = "nl_NL.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
     };
  };
  console.keyMap = "us-acentos";

  # Services.
  services = {

    # Enable GUI.
    xserver = {
      enable = true;

      # Enable nvidia drivers.
      videoDrivers = [ "nvidiaBeta" ];

        # GNOME desktop.
      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "intl";

      # Enable libInput.
      libinput.enable = true;
    };

    # Enable GNOME settings management.
    dbus.packages = [ pkgs.gnome3.dconf ];
    udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

    # Enable CUPS to print documents.
    printing.enable = true;

    # Battery management.
    tlp.enable = true;
  };

  # Programs.
  programs = {
    # Enable fish.
    fish.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };
  
  # Package options
  nixpkgs.config.allowUnfree = true;

  # Default system packages.
  environment.systemPackages = with pkgs; [
    vim
    nano
    nvidia-offload
    # Basic utilitities
    bzip2
    coreutils
    findutils
    gawk
    gzip
    utillinux
    htop
    killall
    xz
    wget
    curl
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


  # Enable Docker
  virtualisation.docker.enable = true;

  # Security settings.
  security = {
    # Enable hardware RNG by using TPM.
    rngd.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
  };

  # Nix daemon config.
  nix = {
    # Automate optimisation.
    autoOptimiseStore = true;
    # Automate garbage collection.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

   virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "lucas" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

