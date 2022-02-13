{ config, pkgs, ... }:

{
  imports = [
    ./gitea
    ./grafana
    ./loki
  ];

  networking.hostName = "nenya";

  users.motd = builtins.readFile ./motd;
}
