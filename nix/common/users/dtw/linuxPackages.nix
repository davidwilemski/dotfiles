{pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    atop
    docker
    docker-compose
    lld_13
    lldb_13
    llvm_13
  ];
}
