{ config, pkgs, ... }:

let
  # Basing structure of some of these imports on
  # github.com/workflow/nixos-config
  #
  # TODO - take over xsession management in home manager
  # See https://github.com/workflow/nixos-config/blob/2a9b597810ae6a26b6182c00206871387fcfd8c4/system/desktop.nix#L31
  # and https://github.com/workflow/nixos-config/blob/2a9b597810ae6a26b6182c00206871387fcfd8c4/home/xsession/default.nix
  imports = [
    ./home/packages.nix
    ./home/xsession
    ./home/i3status-rust.nix
    ./home/home-environment.nix
  ];

in
{
  home.username = "dtw";
  home.homeDirectory = "/home/dtw";

  inherit imports;

  # only enable if you want home manager to manage
  # bash's configuration
  # programs.bash.enable = true;
  programs.bash.enable = false;

  programs.home-manager.enable = true;

  programs.neovim.vimAlias = true;
  programs.neovim.vimdiffAlias = true;

  programs.alacritty = {
    enable = true;
  };

  home.file = {
    ".config/tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/roles/dotfiles/files/.tmux.conf";
    ".config/tmux/plugins"= {
      # recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/roles/dotfiles/files/.tmux/plugins/";
    };

    ".config/nvim/" = {
      # recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/roles/dotfiles/files/.vim/";
    };

    ".inputrc".source = "${config.home.homeDirectory}/dotfiles/roles/dotfiles/files/.inputrc";
  };

  services.flameshot = {
    enable = true;
    #settings = {
    #  General = {
    #    contrastOpacity = 188;
    #    copyPathAfterSave = true;
    #    disabledTrayIcon = false;
    #    drawColor = "#ff0000";
    #    drawFontSize = 8;
    #    drawThickness = 3;
    #    showStartupLaunchMessage = false;
    #  };
    #};
  };

}
