{ config, pkgs, ... }:

{
  imports = [
    ./dotfiles.nix
    ./git.nix

    ./packages.nix
    ./customPackages.nix

    ../../home-manager
  ];

  programs.bash.enable = true;
  programs.fish.enable = true;

  programs.fzf.enableFishIntegration = true;
  programs.fzf.enableBashIntegration = true;

  home.username = "dtw";
  home.homeDirectory = "/home/dtw";
  programs.home-manager.enable = true;
}
