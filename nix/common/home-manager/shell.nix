{ pkgs, ... }:
{
  # apparently currently broken?
  # https://github.com/nix-community/home-manager/issues/2722
  #programs.bash.enable = true;
  programs.fish.enable = true;

  programs.fzf.enableFishIntegration = true;
  programs.fzf.enableBashIntegration = true;
}
