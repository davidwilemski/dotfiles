{ config, pkgs, ... }:

{
  # Mount archivebox data dir over nfs
  environment.systemPackages = with pkgs; [ nfs-utils ]; # required for mount.nfs
  services.rpcbind.enable = true; # needed for NFS
  systemd.mounts = [
    {
      type = "nfs";
      mountConfig = {
        Options = ["noatime"];
      };
      what = "10.12.48.2:/volume1/david/archivebox/data/archive";
      where = "/mnt/archivebox_data_archive";
    }
    {
      type = "nfs";
      mountConfig = {
        Options = ["noatime"];
      };
      what = "10.12.48.2:/volume1/david/archivebox/data/sources";
      where = "/mnt/archivebox_data_sources";
    }
  ];

  systemd.automounts = [
    {
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/mnt/archivebox_data_archive";
    }
    {
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/mnt/archivebox_data_sources";
    }
  ];

  # XXX I didn't end up needing this user :shrug:
  # TODO figure out actually getting docker user and system user to match up
  users.users = {
    archivebox = {
      isSystemUser = true;
      group = "archivebox";
      home = "/var/lib/archivebox";
    };
  };

  users.groups = {
    archivebox = {};
  };

  virtualisation.oci-containers.containers = {
    "archivebox" = {
      # TODO
      # dependsOn = [ "archivebox-sonic" ];

      image = "archivebox/archivebox:0.7.2";
      cmd = ["server" "--quick-init" "0.0.0.0:8000"];

      volumes = [
        "/var/lib/archivebox:/data"
        "/mnt/archivebox_data_archive:/data/archive"
        "/mnt/archivebox_data_sources:/data/sources"
      ];

      ports = [ "8000:8000" ];

      environment = {
        USE_COLOR = "True";
        SHOW_PROGRESS = "False";
        SEARCH_BACKEND_ENGINE = "sonic";
        SEARCH_BACKEND_HOST_NAME = "localhost";
        SEARCH_BACKEND_PASSWORD = "SecretPassword"; # TODO Secrets
        SAVE_ARCHIVE_DOT_ORG = "False";
      };
    };

    "archivebox-sonic" = {
      image = "valeriansaliou/sonic:v1.4.8";

      volumes = [
        "/var/lib/archivebox/sonic:/var/lib/sonic/store/"
        "/var/lib/archivebox/sonic/etc:/etc/sonic"
      ];

      ports = [ "1491:1491" ];

      environment = {
        SEARCH_BACKEND_PASSWORD = "SecretPassword";
      };

      entrypoint = "sonic";
      cmd = [ "-c" "/etc/sonic/config.cfg" ];

      # TODO
      # user = "archivebox:archivebox";
    };
  };
}
