{pkgs, lib, ... }:

let
  unstablePkgs = import (builtins.fetchTarball {
    name = "nixos-unstable-2018-09-12";
    url = "https://github.com/nixos/nixpkgs/archive/bb0359be0a1a08c8d74412fe8c69aa2ffb3f477e.tar.gz";
    sha256 = "14f19wi7b7wiscw3jlqrpcgls83fkkvd3lpgklx25g34vlyhi4kh";
  }) {};
in
{
  home.packages = with pkgs; [
    atop
    docker
    docker-compose
    lld_13
    lldb_13
    llvm_13
    xdg-utils
  ] ++ [
    unstablePkgs.makemkv
  ];
}
