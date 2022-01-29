{ config, pkgs, ... }:

# TODO - do I need to fetch from github instead to support remote deploys of config? Probably.
{

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

}
