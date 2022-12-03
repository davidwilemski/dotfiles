{ config, pkgs, ... }:

{
  services.grafana = {
    enable = true;


    settings = {
      analytics.reporting_enabled = false; # don't report to stats.grafana.net

      "auth.anonymous".enabled = true;

      server = {
        domain = "nenya";
        http_port = 3001;
        http_addr = "0.0.0.0";
      };
    };


  };
}
