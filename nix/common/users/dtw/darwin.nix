{ system ? builtins.currentSystem, ... }:

{
  imports = [
    ./dotfiles.nix
    ./git.nix

    ./packages.nix
    ./customPackages.nix

    ../../home-manager/programs

    ../../home-manager/shell.nix
    ../../home-manager/home-environment.nix
  ];

  programs.alacritty.enable = true;
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
