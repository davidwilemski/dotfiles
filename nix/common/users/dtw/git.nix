{ config, pkgs, ... }:

let
  gitEmailFile = builtins.readFile ../../../ops/secrets/git-config-email;
  gitEmail = builtins.substring 0 ((builtins.stringLength gitEmailFile) - 1) gitEmailFile;
in {
  programs.git = {
    enable = true;

    userName = "David Wilemski";
    userEmail = gitEmail;

    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };

    aliases = {
      di = "divergence";
    };

    ignores = [
      "*.swp"
      "*.swo"
      "*.swn"
      "*.swm"

      ".python-version"
    ];

    extraConfig  = {
      branch = {
        autosetuprebase = "always";
      };
    };
  };
}
