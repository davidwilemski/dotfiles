{ config, pkgs, ... }:

{
  imports = [
    ./gitea
    ./grafana
    ./loki
    # ../../services/caddy
  ];

  networking.hostName = "nenya";

  users.motd = builtins.readFile ./motd;
}
