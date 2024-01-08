# https://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html
{ pkgs, system ? builtins.currentSystem }:

let
  micropub-rs-repo = pkgs.fetchFromGitHub {
    owner = "davidwilemski";
    repo = "micropub-rs";
    rev = "94007314aef70294c88c941639ea4db43ea6cadd";
    sha256 = "m/gLN+CBNnubO7JkNOoBCpSgc40KuPcRqG6Z19u4Z9c=";
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
        rev = "dba9e52c4f3789e20d8a95920d007a30a6b769ad";
        sha256 = "90PjSbdCoAB0pbBLovNVXJjDtVmnTneIigj6Q3Lq1V4=";
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

    # pynvml = pkgs.python3Packages.pynvml.overrideAttrs (finalAttrs: previousAttrs: {
    #   patches = [ ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch ];
    # });

    atop = pkgs.atop.overrideAttrs (finalAttrs: previousAttrs: {
      # pythonPath = [ pynvml ];
      makeWrapperArgs = ["--set LD_LIBRARY_PATH /var/run/opengl-driver/lib/"];
    });
}

