{ config, pkgs, lib, ... }:

{
  options = {
    dtw.linuxDesktop = {
      enable = lib.mkEnableOption "Enables GUI programs used in Linux desktop environment";
    };
  };
}
