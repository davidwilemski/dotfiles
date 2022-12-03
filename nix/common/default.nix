{ config, lib, pkgs, ... }:

{
  imports = [
    ./users
    ./desktop.nix
    ./monitoring.nix

    ./services/promtail
    ./services/systemd-resolved
  ];

  boot.cleanTmpDir = true;

  nix.settings.auto-optimise-store = true;

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=14day
  '';

  programs.mosh.enable = true;
}
