{ config, lib, pkgs, ... }:

{
  imports = [
    ./users
    ./desktop.nix
    ./monitoring.nix
  ];

  boot.cleanTmpDir = true;

  nix.autoOptimiseStore = true;

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=14day
  '';

  services.resolved = {
    enable = true;
    dnssec = "false";
  };
}
