let
  pkgs = import (builtins.fetchTarball {
    name = "nixos-22.11";
    url = "https://releases.nixos.org/nixos/22.11/nixos-22.11.1580.e285dd0ca97/nixexprs.tar.xz";
    sha256 = "0jd190jwgwv30dkcm1y3q0f4cz8xak3x1vk4fgqaz2pl5zcfcaj5";
    # name = "nixos-unstable";
    # url = "https://releases.nixos.org/nixos/unstable/nixos-23.05pre441903.0f213d0fee8/nixexprs.tar.xz";
    # sha256 = "15zhqlmqjzljlczv188z74b25gmdhkf8ngvqb968fsfz31q79nvf";
  }) {
    config = {
      allowUnfree = true;
    };
  };
in
{ ... }:

pkgs
