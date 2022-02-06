{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "David Wilemski";
    userEmail= "david@wilemski.org";

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
