{pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    atop
    cargo
    clang_13
    docker
    docker-compose
    fd
    file
    fpp
    fzf
    git
    git-annex
    git-revise
    httpie
    inetutils
    killall
    lld_13
    lldb_13
    llvm_13
    neovim
    nvd
    pstree
    pv
    qrencode
    ripgrep
    rustc
    #rustup
    tmux
    tree
    zstd
  ];
}
