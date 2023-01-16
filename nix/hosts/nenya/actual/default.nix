{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers = {
    "actual-server" = {
      # TODO use non-local image
      image = "actual-server_actual_server";

      volumes = [
        "/var/lib/actual-server/server-files:/app/server-files"
        "/var/lib/actual-server/user-files:/app/user-files"
      ];

      ports = [ "5006:5006" ];
    };
  };
}
