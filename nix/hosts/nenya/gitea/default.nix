{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    dump.enable = true;
    disableRegistration = true;

    domain = "nenya";

    settings = {
      metrics = {
        ENABLED = true;
        # TODO Add secret auth token
      };
      server = {
        SSH_DOMAIN = "nenya"; # supposedly defaults to %(DOMAIN)s but not working with top-level domain setting?
      };
    };
  };
}
