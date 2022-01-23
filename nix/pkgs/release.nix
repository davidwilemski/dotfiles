let
  pkgs = import <nixpkgs> { };
  myPkgs = (import ./.) pkgs;
in rec {
  inherit (myPkgs) csv-diff;
  myPkgs.csv-diff
}
