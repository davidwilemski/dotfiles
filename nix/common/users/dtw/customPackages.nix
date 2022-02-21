{pkgs, lib, ... }:

let
  customPkgs = import ../../../custom-packages.nix { };
in {
  home.packages = with customPkgs; [
    customPkgs.csv-diff
    customPkgs.llama
  ];
}
