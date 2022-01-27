{ config, pkgs, ... }:

{
  imports = [
    ../../../home/packages.nix
  ];

  home.username = "dtw";
  home.homeDirectory = "/home/dtw";
  programs.home-manager.enable = true;
}
