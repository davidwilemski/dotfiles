{
  network = {
    description = "home network";
  };

  "narya" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "192.168.0.196";

    networking.hostName = "narya";
    networking.hostId = "7e21fd2e";

    imports = [
      ../../common/hardware/optiplex-3060
      ../../hosts/narya/configuration.nix
    ];

  };

  "nenya" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "192.168.0.184";

    networking.hostName = "nenya";
    networking.hostId = "5f25fbf9";

    imports = [
      ../../common/hardware/optiplex-3060
      ../../hosts/nenya/configuration.nix
    ];

  };

  "vilya" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "192.168.0.151";

    networking.hostName = "vilya";
    networking.hostId = "eab830d1";

    imports = [
      # No optiplex import - this is an optiplex 3080
      ../../hosts/vilya/configuration.nix
    ];

  };
}
