{pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    atop
    lld_13
    lldb_13
    llvm_13
  ]
}
