{ config, pkgs, ... }:

let
  fetchKeys = username:
    (builtins.fetchurl "https://github.com/${username}.keys");
in {
  imports = [
    ./hardware-configuration.nix

    ../../../common
    # TODO: import home manager config
    # perhaps relocate dotfiles/nix/home.nix (and nix/home/) to
    # nix/users/home-manager.nix or nix/home-manager?
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.kernelParams = [ "zfs.zfs_arc_max=1073741824" ];

  security.sudo.wheelNeedsPassword = false;

  networking.interfaces.enp1s0.useDHCP = true;

  nixpkgs.config.allowUnfree = true;

  networking.firewall.enable = false;

  users.users.root.openssh.authorizedKeys.keyFiles = [ (fetchKeys "davidwilemski") ];

  services.openssh.enable = true;
  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [ wget vim zfs ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
}