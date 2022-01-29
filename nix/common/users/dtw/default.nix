{ config, pkgs, ... }:

{
  imports = [
    ./dotfiles.nix
    ./packages.nix

    ../../home-manager
  ];

  programs.bash.enable = true;

  home.username = "dtw";
  home.homeDirectory = "/home/dtw";
  programs.home-manager.enable = true;
}
