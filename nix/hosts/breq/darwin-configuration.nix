{ config, pkgs, ... }:

let

  sbt_jdk11 = pkgs.sbt.override { jre = pkgs.jdk11; };

in {

  imports = [
    <home-manager/nix-darwin>
  ];

  users.users.dwilemski = {
    name = "dwilemski";
    home = "/Users/dwilemski";
  };

  home-manager.users.dwilemski = (import ../../common/users/dtw/darwin.nix);

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    alacritty
    awscli2
    coursier
    fnm
    jdk11
    metals
    mysql80
    neovim
    octant
    rbenv
    sbt_jdk11
    scala_2_12
    thrift
    vim
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/dotfiles/nix/hosts/breq/darwin-configuration.nix
  environment.darwinConfig = "$HOME/dotfiles/nix/hosts/breq/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.fish.enable = true;

  programs.fish.interactiveShellInit = ''
    status --is-interactive; and rbenv init - fish | source
    fnm env | source

    if test -f "$HOME/.work/env"
      source "$HOME/.work/env"
    end

    if test -f "$HOME/.work/functions"
      source "$HOME/.work/functions"
    end
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  # system.stateVersion = 4;
}
