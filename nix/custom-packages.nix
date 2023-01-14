# https://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html
{ pkgs, system ? builtins.currentSystem }:

let
  micropub-rs-repo = pkgs.fetchFromGitHub {
    owner = "davidwilemski";
    repo = "micropub-rs";
    rev = "367a57e84a65006f8b388b860f9f6a5a72cabda4";
    sha256 = "a9dXbkex/Mzeu0fwcZCVefNYdIInHTqNbdfUY1Isvbg=";
  };

  rustyblobjectstore-repo = pkgs.fetchFromGitHub {
    owner = "davidwilemski";
    repo = "rustyblobjectstore";
    rev = "ec4cf9ba27c5d5be21a8ad3a31de9ffe5455e5c1";
    sha256 = "wUKOzOMaNU5dRlSE7I39l1Wwz5tLWQRJvM1TJoq9pwo=";
  };

  # pynvml-nixpkgs = import (pkgs.fetchFromGitHub {
  #   owner = "davidwilemski";
  #   repo = "nixpkgs";
  #   rev = "27513ed374ff36b7039ae7d594c85f28f49962ac";
  #   sha256 = "gTSz9POZmYkr1idx/Sm3kaDfNvyDvMRhITqfpf1pzDw=";
  # }) { inherit system; };
  pynvml-nixpkgs = import (/home/dtw/dev/nixos/nixpkgs) { inherit system; };
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

    # nvidia-ml-py = pkgs.pythonPackages.nvidia-ml-py.overrideAttrs (finalAttrs: previousAttrs: {
    #   patches = [ ./pynvml.patch ];
    # });

    pynvml = pkgs.python3Packages.pynvml.overrideAttrs (finalAttrs: previousAttrs: {
      # patches = [ ./pynvml.patch ];
      patches = [ ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch ];
    });

    atop = pkgs.atop.overrideAttrs (finalAttrs: previousAttrs: {
      # pythonPath = previousAttrs.pythonPath ++ [ pynvml ]; 
      pythonPath = [ pynvml-nixpkgs.python3Packages.pynvml ];
      # The below lines _do work_
      # buildInputs = previousAttrs.buildInputs ++ [ pkgs.python310Packages.nvidia-ml-py ];  # THIS MAY NOT BE NEEDED
      # pythonPath = [ pkgs.python310Packages.nvidia-ml-py ]; 

      # patches = previousAttrs.patches ++ [ ./atop-py3compat-1.patch ];
    });
}

