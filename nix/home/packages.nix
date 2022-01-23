{pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    alacritty
    atop
    cargo
    clang_13
    docker
    docker-compose
    fd
    file
    flameshot
    fpp
    fzf
    git
    git-annex
    git-revise
    gpx-viewer
    hotspot
    httpie
    killall
    lld_13
    lldb_13
    llvm_13
    neovim
    pstree
    pv
    qrencode
    ripgrep
    rustc
    #rustup
    tmux
    tree
    vlc
    zoom-us
    zstd
  ];
}
