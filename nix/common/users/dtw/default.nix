{ config, pkgs, system ? builtins.currentSystem, ... }:

{
  imports = [
    ./dotfiles.nix
    ./git.nix

    ./packages.nix
    ./linuxPackages.nix
    ./customPackages.nix

    ../../home-manager
  ];

  programs.bash.enable = true;
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      { name ="async-prompt"; src=pkgs.fishPlugins.async-prompt.src; }
      { name ="pure"; src=pkgs.fishPlugins.pure.src; }
    ];
    interactiveShellInit = ''
      set -g async_prompt_functions _pure_prompt_git
      set -U pure_separate_prompt_on_error true
      set -U pure_show_system_time true
      set -U pure_show_subsecond_command_duration true
    '';

  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.fzf.enableFishIntegration = true;
  programs.fzf.enableBashIntegration = true;

  home.username = "dtw";
  home.homeDirectory = "/home/dtw";
  home.stateVersion = "18.09";

  programs.home-manager.enable = true;
}
