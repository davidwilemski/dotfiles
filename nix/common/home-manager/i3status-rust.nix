{ pkgs, lib, nixosConfig, ... }:

{
  config = lib.mkIf nixosConfig.dtw.desktop.enable {
    programs.i3status-rust = {
      enable = true;
      #bars.bottom = bars.default;
      bars = {
        bottom = {
          blocks = [
            {
              block = "docker";
              interval = 30;
              format = "{running}";
            }
            {
              block = "disk_space";
              path = "/";
              alias = "/";
              info_type = "available";
              unit = "GB";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
            }
            {
              block = "memory";
              display_type = "memory";
              format_mem = "{mem_used}/{mem_total} ({mem_used_percents})";
              format_swap = "{swap_used_percents}";
              interval = 1;
            }
            {
              block = "cpu";
              interval = 1;
            }
            {
              block = "load";
              interval = 1;
              format = "{1m}";
            }
            {
              block = "sound";
            }
            {
              block = "time";
              interval = 15;
              format = "%a %Y-%m-%d %R";
            }
          ];
          icons = "awesome";
          theme = "nord-dark";
          #settings = {
          #  theme = {
          #    name = "nord-dark";
          #  };
          #};
        };
      };
    };
  };
}
