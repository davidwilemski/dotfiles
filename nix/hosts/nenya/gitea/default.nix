{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    dump.enable = true;


    rootUrl = "https://gitea.flowerbox.house/";
    domain = "git.flowerbox.house";

    settings = {
      metrics = {
        ENABLED = true;
        # TODO Add secret auth token
      };
      server = {
        SSH_DOMAIN = "git.flowerbox.house"; # supposedly defaults to %(DOMAIN)s but not working with top-level domain setting?
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };
}
