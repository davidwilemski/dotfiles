{ config, pkgs, lib, ... }:

let
  cfg = config.dtw.systemd-resolved;
in {
  options.dtw.systemd-resolved = {
    enable = lib.mkEnableOption "Enables systemd-resolved config on host";
  };

  config = lib.mkIf cfg.enable {

    services.resolved = {
      enable = true;
      dnssec = "false";
    };
  };
}
