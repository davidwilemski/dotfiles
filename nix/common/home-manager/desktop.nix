{ config, lib, pkgs, nixosConfig, ... }:

let
  cfg = config.dtw.linuxDesktop;

  unstablePkgs = import (builtins.fetchTarball {
    name = "nixos-unstable-2018-09-12";
    url = "https://github.com/nixos/nixpkgs/archive/bb0359be0a1a08c8d74412fe8c69aa2ffb3f477e.tar.gz";
    sha256 = "14f19wi7b7wiscw3jlqrpcgls83fkkvd3lpgklx25g34vlyhi4kh";
  }) { config = { allowUnfree = true;}; };
in {
  imports = [
    ./xsession
    ./i3status-rust.nix
  ];

  config = lib.mkIf nixosConfig.dtw.linuxDesktop.enable {
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
      handbrake
      hotspot
      vlc
      xcape
      zoom-us
    ] ++ [
      unstablePkgs.makemkv
    ];
  };
}
