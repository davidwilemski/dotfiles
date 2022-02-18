{ config, pkgs, ... }:

{
  imports = [
    ./dotfiles.nix
    ./git.nix
    ./packages.nix

    ../../home-manager
  ];

  programs.bash.enable = true;
  programs.fish.enable = true;

  home.username = "dtw";
  home.homeDirectory = "/home/dtw";
  programs.home-manager.enable = true;
}
