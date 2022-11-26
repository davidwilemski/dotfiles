{
  network = {
    description = "home network";
  };

  "narya" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "10.12.48.5";
    # deployment.targetHost = "narya";
    deployment.tags = [ "homelab" ];

    networking.hostName = "narya";
    networking.hostId = "7e21fd2e";

    imports = [
      ../../common/hardware/optiplex-3060
      ../../hosts/narya/configuration.nix
    ];

  };

  "nenya" = { config, pkgs, lib, ... }: {
    deployment = {
      targetUser = "root";
      targetHost = "10.12.48.4";
      tags = [ "homelab" ];
      secrets = {
        "loki-secrets.env" = {
          source = "../secrets/loki-secrets.env";
          destination = "/var/secrets/loki-secrets.env";
          owner.user = "loki";
          owner.group = "root";
          permissions = "0400"; # this is the default
          action = ["sudo" "systemctl" "restart" "dtw-loki.service"];
        };
      };
    };

    networking.hostName = "nenya";
    networking.hostId = "5f25fbf9";

    imports = [
      ../../common/hardware/optiplex-3060
      ../../hosts/nenya/configuration.nix
    ];

  };

  "vilya" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "10.12.48.3";
    deployment.tags = [ "homelab" ];

    networking.hostName = "vilya";
    networking.hostId = "eab830d1";

    imports = [
      # No optiplex import - this is an optiplex 3080
      ../../hosts/vilya/configuration.nix
    ];

  };

  # Main desktop
  "faolin" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    # deployment.targetHost = "192.168.0.156";
    deployment.targetHost = "faolin";

    networking.hostName = "faolin";

    imports = [
      ../../hosts/faolin/configuration.nix
    ];

  };

  # Router (tinypc 4x2.5gbe
  "barahir" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    # deployment.targetHost = "192.168.0.102";
    deployment.targetHost = "10.12.48.1";

    networking.hostName = "barahir";

    imports = [
      ../../hosts/barahir/configuration.nix
    ];
  };
}
