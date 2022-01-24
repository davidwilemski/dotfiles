{ config, pkgs, ... }:

{
  imports = [
  ];

  networking.hostName = "nenya";

  users.motd = builtins.readFile ./motd;
}
