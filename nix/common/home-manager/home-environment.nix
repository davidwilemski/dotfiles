{ pkgs, ... }:
{

  home.shellAliases = {
    vim = "nvim";
  };

  # environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    PATH = "$HOME/bin:$PATH";
  };

  # ensure macos path_helper doesn't overwrite PATH
  # See this about macos path_helper https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
  programs.fish.loginShellInit = ''
    if test -n "$TMUX"
      and test -f "/etc/profile"
      set PATH "$HOME/bin:$PATH" # needed to ensure ~/bin is placed first in PATH
    end
  '';
}
