{ config, pkgs, lib, ... }:

{
  config.services.caddy = {
    enable = true;
    email = "caddy@wilemski.org"
    config = ''
    home-assistant.flowerbox.house {
      reverse_proxy nenya:8123
    }
    '';
  };
}
