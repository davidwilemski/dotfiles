{ config, lib, pkgs, nixosConfig, ... }:

let
  cfg = config.dtw.desktop;
in {
  imports = [
    ./xsession
    ./i3status-rust.nix
  ];

  # options = {
  #   dtw.desktop = {
  #     enable = lib.mkEnableOption "Enables GUI programs used in desktop environment";
  #   };
  # };

  config = lib.mkIf nixosConfig.dtw.desktop.enable {
    programs.alacritty.enable = true;

    services.flameshot = {
      enable = true;
      #settings = {
      #  General = {
      #    contrastOpacity = 188;
      #    copyPathAfterSave = true;
      #    disabledTrayIcon = false;
      #    drawColor = "#ff0000";
      #    drawFontSize = 8;
      #    drawThickness = 3;
      #    showStartupLaunchMessage = false;
      #  };
      #};
    };

    services.xcape = {
      enable = true;
      timeout = 100;
      mapExpression = { Caps_Lock = "Escape|Control_L"; };
    };

    home.packages = with pkgs; [
      alacritty
      flameshot
      gpx-viewer
      hotspot
      vlc
      zoom-us
    ];
  };
}
