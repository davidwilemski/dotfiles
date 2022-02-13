{ config, pkgs, ... }:

{
  services.grafana = {
    enable = true;

    addr = "0.0.0.0";

    analytics.reporting.enable = false; # don't report to stats.grafana.net

    auth.anonymous.enable = true;

    domain = "nenya";
    port = 3001;

  };
}
