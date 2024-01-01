{ config, pkgs, ... }:

{
  imports = [
    ../../common/services/sendzfssnapshot
    ../../common/services/davidwilemski.com

    ./caddy
  ];

  networking.hostName = "narya";

  users.motd = builtins.readFile ./motd;

  dtw.services.davidwilemski-com = {
    enable = true;

    extraConfig = {
      blobject_store_base_uri = "http://localhost:3031";

      site = {
        site_name = "David's Blog";
        menu_items = [
          ["About Me" "/about"]
          ["Archive" "/archives"]
        ];
        socials = [
          "https://github.com/davidwilemski"
          "https://twitter.com/davidwilemski"
          "https://hachyderm.io/@davidwilemski"
        ];
      };

      micropub = {
        host_website = "https://www.davidwilemski.com/";
        media_endpoint = "https://www.davidwilemski.com/media";
        micropub_endpoint = "/micropub";
      };
    };
  };
}
