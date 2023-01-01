{ config, pkgs, ... }:

{
  imports = [
    ../../common/services/sendzfssnapshot
    ../../common/services/davidwilemski.com
  ];

  networking.hostName = "narya";

  users.motd = builtins.readFile ./motd;

  dtw.services.davidwilemski-com.enable = true;
}
