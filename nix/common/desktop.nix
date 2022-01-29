{ config, pkgs, lib, ... }:

{
  options = {
    dtw.desktop = {
      enable = lib.mkEnableOption "Enables GUI programs used in desktop environment";
    };
  };
}
