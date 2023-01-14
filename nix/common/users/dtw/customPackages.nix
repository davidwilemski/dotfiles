{pkgs, lib, ... }:

let
  customPkgs = import ../../../custom-packages.nix { inherit pkgs; };
in {
  home.packages = with customPkgs; [
    customPkgs.csv-diff
    customPkgs.llama
  ];
}
