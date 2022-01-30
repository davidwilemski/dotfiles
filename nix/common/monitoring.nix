{ config, ... }:

{
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        openFirewall = true;
      };
    };
  };

  services.cadvisor = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 9101;
  };
}
