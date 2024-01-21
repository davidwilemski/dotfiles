{pkgs, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;

    manual.manpages.enable = true;
  };

  home.packages = with pkgs; [
    _1password
    cargo
    clang_13
    fd
    file
    fishPlugins.async-prompt
    fishPlugins.pure
    flyctl
    fpp
    fzf
    git
    git-annex
    git-revise
    httpie
    inetutils
    jq
    k9s
    killall
    lazycli
    lazydocker
    lazygit
    morph
    neovim
    niv
    nvd
    ouch
    pstree
    pv
    qrencode
    ripgrep
    rust-analyzer
    rustc
    #rustup
    sqlite
    tmux
    tree
    xh
    zstd
  ];
}
