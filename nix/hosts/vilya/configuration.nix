# hardware: optiplex 3080
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../common
    ../../common/services/sendzfssnapshot
    # TODO: import home manager config
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.kernelPackages = pkgs.linuxPackages_5_15;

  security.sudo.wheelNeedsPassword = false;

  networking.interfaces.enp1s0.useDHCP = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "vilya";
  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [ wget vim zfs ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;

  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  users.mutableUsers = false;

  users.motd = builtins.readFile ./motd;

  system.stateVersion = "21.11";
}
