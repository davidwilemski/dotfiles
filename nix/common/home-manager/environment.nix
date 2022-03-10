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
}
