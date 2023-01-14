{ config, pkgs, ... }:

{
  imports = [
    ../../../common/services/loki
  ];

  services.dtw.loki = {
    enable = true;

    envFile = /var/secrets/loki-secrets.env;

    configuration = {
      auth_enabled = false;

      server = {
        http_listen_address = "0.0.0.0";
        http_listen_port = 3100;
      };

      ingester = {
        lifecycler = {
          address = "0.0.0.0";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_encoding = "zstd";
        max_chunk_age = "2h";
      };

      schema_config = {
        configs = [
          {
            from = "2020-05-15";
            store = "boltdb-shipper";
            object_store = "s3";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/index";
          cache_location = "/var/lib/loki/index_cache";
          shared_store = "s3";
        };

        aws = {
          s3 = ''http://loki:''${MINIO_SECRET_KEY}@100.65.207.115:9000/loki'';
          s3forcepathstyle = true;
        };
      };

      limits_config = {
        enforce_metric_name = false;
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      compactor = {
        working_directory = "/var/lib/loki/compactor";
        shared_store = "s3";
      };
    };

    extraFlags = [
      "-config.expand-env=true"
    ];

  };
}
