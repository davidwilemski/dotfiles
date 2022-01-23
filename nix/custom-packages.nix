# https://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html
{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
rec {
  csv-diff = import ./pkgs/csv-diff;

  llama = import ./pkgs/llama {
    inherit (pkgs) fetchFromGitHub buildGoPackage;
  };
}

