# https://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html
{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  micropub-rs-repo = pkgs.fetchFromGitHub {
    owner = "davidwilemski";
    repo = "micropub-rs";
    rev = "028f7921f72551c6f642cb540bccb2be0985f833";
    sha256 = "2YC//E2QQhgteLeleBe3/cTfDPEZvzOm1fN28GMSTp8=";
  };

  rustyblobjectstore-repo = pkgs.fetchFromGitHub {
    owner = "davidwilemski";
    repo = "rustyblobjectstore";
    rev = "ec4cf9ba27c5d5be21a8ad3a31de9ffe5455e5c1";
    sha256 = "wUKOzOMaNU5dRlSE7I39l1Wwz5tLWQRJvM1TJoq9pwo=";
  };
in
rec {
  csv-diff = import ./pkgs/csv-diff {
    lib = pkgs.lib;
    python3Packages = pkgs.python3Packages;
    fetchFromGitHub = pkgs.fetchFromGitHub;
    dictdiffer = dictdiffer;
  };

  dictdiffer = with pkgs; import ./pkgs/pythonPackages/dictdiffer {
    inherit lib;
    buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
    fetchPypi = pkgs.python3Packages.fetchPypi;
    pytestCheckHook = pkgs.python3Packages.pytestCheckHook;
    pytest-cov = pkgs.python3Packages.pytest-cov;
    pytest-isort = pkgs.python3Packages.pytest-isort;
    setuptools-scm = pkgs.python3Packages.setuptools-scm;
  };

  llama = import ./pkgs/llama {
    inherit (pkgs) fetchFromGitHub buildGoPackage;
  };

  micropub-rs = import "${micropub-rs-repo}/micropub-rs.nix" {};

  rustyblobjectstore = import "${rustyblobjectstore-repo}" {};

  blue-penguin-theme =
    pkgs.stdenv.mkDerivation {
      pname = "blue-penguin-theme";
      name = "blue-penguin";
      src = pkgs.fetchFromGitHub {
        owner = "davidwilemski";
        repo = "blue-penguin";
        rev = "5351e1e079d992b92822deb92b99ece25c70f8f5";
        sha256 = "PYAC0Mc0iu3xYcAcJ1g4JjNrmrIlhdOZjFq5aLjd0sI=";
      };

      dontPatch = true;
      dontConfigure = true;

      installPhase = ''
        mkdir -p $out/static $out/templates
        cp -r static $out/
        cp -r templates $out/
      '';

      dontFixup = true;
    };
}

