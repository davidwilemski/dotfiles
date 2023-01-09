{ config, lib, pkgs, ... }:

let
  system = builtins.currentSystem;
  isLinux = (builtins.elem "linux" (builtins.split "(-)" system));

  customPkgs = import ../custom-packages.nix { };
in
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

  programs.atop.enable = isLinux;
  programs.atop.package = customPkgs.atop;
  programs.mosh.enable = true;
}
