{ config, lib, pkgs, ... }:

let
  system = builtins.currentSystem;
  isLinux = (builtins.elem "linux" (builtins.split "(-)" system));
in
{
  imports = [
    ./users
    ./desktop.nix
    ./monitoring.nix

    ./services/promtail
    ./services/systemd-resolved
  ];

  boot.tmp.cleanOnBoot = true;

  nix.settings.auto-optimise-store = true;

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=14day
  '';

  programs.atop.enable = isLinux;
  programs.fish.enable = true;
  programs.mosh.enable = true;
}
