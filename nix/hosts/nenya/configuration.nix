{ config, pkgs, ... }:

{
  imports = [
    ./gitea
  ];

  networking.hostName = "nenya";

  users.motd = builtins.readFile ./motd;
}
