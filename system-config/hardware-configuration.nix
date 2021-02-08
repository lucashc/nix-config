# Hardware configuration
# Please do not modify or regenerate.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "btrfs" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/627f1843-17a6-4a2a-862a-cbf8b7a0defa";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" "discard=async" ];
    };

  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-uuid/71cd64f5-a4e3-4ce2-bf97-d80bfe7ed4bc";
    allowDiscards = true;
  };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/627f1843-17a6-4a2a-862a-cbf8b7a0defa";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" "discard=async" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A4F7-81C6"; 
      fsType = "vfat";
      options = [ "discard" ];
    };

  swapDevices = [
      { device = "/swap/swapfile";
        size = 16000; 
        }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
