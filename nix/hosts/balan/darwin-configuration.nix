{ config, pkgs, ... }:

{

  imports = [
    <home-manager/nix-darwin>
  ];

  users.users.dtw = {
    name = "dtw";
    home = "/Users/dtw";
  };

  home-manager.users.dtw = (import ../../common/users/dtw/darwin.nix);

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    alacritty
    openssh
    neovim
    vim
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/dotfiles/nix/hosts/balan/darwin-configuration.nix
  environment.darwinConfig = "$HOME/dotfiles/nix/hosts/balan/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
