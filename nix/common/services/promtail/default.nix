{ config, pkgs, lib, ... }:

let
  cfg = config.dtw.promtail;
  host = config.networking.hostName;
in {
  options.dtw.promtail = {
    enable = lib.mkEnableOption "Enables promtail config on host";
  };

  config = lib.mkIf cfg.enable {
    services.promtail.enable = true;

    services.promtail.configuration = {
      server = {
        http_listen_port = 9080;
        grpc_listen_port = 0;
      };

      positions.filename = "/tmp/promtail_positions.yaml";

    clients = [
      { url = "http://nenya:3100/loki/api/v1/push"; }
    ];

    scrape_configs = [
      {
        job_name = "journal";
        journal = {
          max_age = "12h";
          labels = {
            job = "systemd-journal";
            host = host;
          };
        };
        relabel_configs = [
          {
            source_labels = ["__journal__systemd_unit"];
            target_label = "unit";
          }
        ];
      }
    ];
    };
  };
}
