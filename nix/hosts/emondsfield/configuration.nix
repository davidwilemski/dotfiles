/*
Host: Dell Inc. 0KYJ8C (Optiplex 7060)
CPU: Intel i5-8500T (6) @ 800MHz
GPU: Intel CoffeeLake-S GT2 [UHD Graphics 630]
Memory: 15805MiB
*/
{ config, pkgs, ... }:

let
  fetchKeys = username:
    (builtins.fetchurl "https://github.com/${username}.keys");
in {

  imports = [
    ./hardware-configuration.nix

    ../../common
    ../../common/services/sendzfssnapshot
    # TODO: import home manager config
    # perhaps relocate dotfiles/nix/home.nix (and nix/home/) to
    # nix/users/home-manager.nix or nix/home-manager?
  ];

  networking.hostName = "emondsfield";

  users.motd = builtins.readFile ./motd;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 15;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.kernelParams = [ "zfs.zfs_arc_max=1073741824" ];

  security.sudo.wheelNeedsPassword = false;

  networking.interfaces.eno1.useDHCP = true;

  networking.firewall.enable = false;

  users.users.root.openssh.authorizedKeys.keyFiles = [ (fetchKeys "davidwilemski") ];

  services.openssh.enable = true;
  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [ wget vim zfs ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  dtw.promtail = {
    enable = true;
  };

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

  system.stateVersion = "21.11";
}
