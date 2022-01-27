{ config, lib, pkgs, ... }:

{
  imports = [
    ./users
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
