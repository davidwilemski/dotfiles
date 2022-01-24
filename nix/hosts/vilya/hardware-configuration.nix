{ config, pkgs, modulesPath, lib, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # the optiplex 2080 has nvme storage
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  networking.hostId = "eab830d1";

  fileSystems."/" = {
    device = "rpool/safe/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/safe/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p3";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/nvme0n1p2"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
