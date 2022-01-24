{ config, pkgs, ... }:

{
  imports = [
  ];

  networking.hostName = "narya";

  users.motd = builtins.readFile ./motd;
}
