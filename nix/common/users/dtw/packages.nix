{pkgs, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;

    manual.manpages.enable = true;
  };

  home.packages = with pkgs; [
    _1password
    atop
    cargo
    clang_13
    fd
    file
    fpp
    fzf
    git
    git-annex
    git-revise
    httpie
    inetutils
    jq
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
    xh
    zstd
  ];
}
