{ config, pkgs, ... }:

let
  # fetchKeys = username:
  #   (builtins.fetchurl "https://github.com/${username}.keys");
in {
  imports = [
    #installer-only ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  networking.interfaces.enp1s0.useDHCP = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "install";
  networking.firewall.enable = false;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHU1wALDnDMgO8YgP47S2wUtK7uFlYVxnVrIbvXL0vA"
  ];
  # users.users.root.openssh.authorizedKeys.keyFiles = [ (fetchKeys "davidwilemski") ];

  services.openssh.enable = true;
  users.mutableUsers = false;
}
