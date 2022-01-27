{pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    alacritty
    flameshot
    gpx-viewer
    hotspot
    vlc
    zoom-us
  ];
}
