{ config, pkgs, ... }:

let
  fetchKeys = username: (builtins.fetchurl "https://github.com/${username}.keys");
in {
  users.users.dtw = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "docker"
    ];

    openssh.authorizedKeys.keys = (builtins.filter builtins.isString (builtins.split "\n" (builtins.readFile (fetchKeys "davidwilemski"))));
  };

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.dtw.openssh.authorizedKeys.keys;
}
