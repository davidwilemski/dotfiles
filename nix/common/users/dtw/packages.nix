{pkgs, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;

    manual.manpages.enable = true;
  };

  home.packages = with pkgs; [
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
    morph
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
