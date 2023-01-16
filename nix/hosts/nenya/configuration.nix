{ config, pkgs, ... }:

{
  imports = [
    ./gitea
    ./grafana
    ./loki
    ./archivebox
    # ../../services/caddy
  ];

  networking.hostName = "nenya";

  users.motd = builtins.readFile ./motd;

  dtw.systemd-resolved.enable = true;

  # Stick with docker for now; experiment with podman once all containers on
  # nenya are defined with oci-containers in nix cfg.
  virtualisation.oci-containers.backend = "docker";
}
