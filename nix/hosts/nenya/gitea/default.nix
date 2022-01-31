{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    disableRegistration = true;
  };
}
