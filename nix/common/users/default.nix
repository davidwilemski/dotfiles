{ config, pkgs, ... }:

let
  fetchKeys = username: (builtins.fetchurl "https://github.com/${username}.keys");
in {
  imports = [ <home-manager/nixos> ];

  users.extraUsers.dtw.shell = pkgs.fish;
  users.users.dtw = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "docker"
      "cdrom"
    ];

    openssh.authorizedKeys.keys = (builtins.filter builtins.isString (builtins.split "\n" (builtins.readFile (fetchKeys "davidwilemski"))));
  };

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.dtw.openssh.authorizedKeys.keys;

  home-manager.users.dtw = (import ./dtw);
}
