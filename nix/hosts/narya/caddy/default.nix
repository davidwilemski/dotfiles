{ config, pkgs, lib, ... }:

let
  namecheapSecrets = builtins.readFile ../../../ops/secrets/namecheap;
in
{
  config.services.caddy = {
    enable = true;
    email = "caddy@wilemski.org";

    globalConfig = ''
      servers {
        metrics
      }
    '';

    virtualHosts."actual.flowerbox.house" = {
      hostName = "actual.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:5006
      '';
    };

    virtualHosts."caddy-metrics-narya.flowerbox.house" = {
      hostName = "caddy-metrics-narya.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        metrics /metrics
      '';
    };

    virtualHosts."gitea.flowerbox.house" = {
      hostName = "gitea.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:3000
      '';
    };

    virtualHosts."grafana.flowerbox.house" = {
      hostName = "grafana.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:3001
      '';
    };

    virtualHosts."home-assistant.flowerbox.house" = {
      hostName = "home-assistant.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:8123
      '';
    };

    virtualHosts."loki.flowerbox.house" = {
      hostName = "loki.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:3100
      '';
    };

    virtualHosts."music.flowerbox.house" = {
      hostName = "music.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy jeod:8800
      '';
    };

    virtualHosts."prometheus.flowerbox.house" = {
      hostName = "prometheus.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy jeod:9090
      '';
    };

    virtualHosts."synology.flowerbox.house" = {
      hostName = "synology.flowerbox.house";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy jeod:5000
      '';
    };

    virtualHosts."flowerboxarchive.com" = {
      hostName = "flowerboxarchive.com";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerboxarchive.com";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:8000
      '';
    };

    virtualHosts."www.flowerboxarchive.com" = {
      hostName = "www.flowerboxarchive.com";
      listenAddresses = [ "100.106.235.107" ];
      useACMEHost = "flowerboxarchive.com";
      extraConfig = ''
        redir https://flowerboxarchive.com{uri}
      '';
    };
  };

  config.security.acme = {
    acceptTerms = true;
    defaults.email = "david+acme@wilemski.org";
    certs."flowerbox.house" = {
      domain = "*.flowerbox.house";
      dnsProvider = "namecheap";
      credentialsFile = "/var/lib/secrets/certs.secret";
    };

    certs."flowerboxarchive.com" = {
      domain = "*.flowerboxarchive.com";
      extraDomainNames = [ "flowerboxarchive.com" ];
      dnsProvider = "namecheap";
      credentialsFile = "/var/lib/secrets/certs.secret";
    };
  };

  config.systemd.services.dtw-dns-acme-namecheap-conf = {
    requiredBy = [
      "acme-flowerbox.house.service"
      "acme-flowerboxarchive.com.service"
    ];
    before = [
      "acme-flowerbox.house.service"
      "acme-flowerboxarchive.com.service"
    ];
    unitConfig = {
      ConditionPathExists = "!/var/lib/secrets/certs.secret";
    };
    serviceConfig = {
      Type = "oneshot";
      UMask = 0077;
    };

    script = ''
      mkdir -p /var/lib/secrets
      chmod 755 /var/lib/secrets

      cat > /var/lib/secrets/certs.secret << EOF
        ${namecheapSecrets}
      EOF
      chmod 400 /var/lib/secrets/certs.secret
    '';
  };

  config.dtw.promtail.extraScrapeConfigs = [
    {
      job_name = "caddy-access-logs";
      static_configs = [
        {
          labels = {
            __path__ = "/var/log/caddy/*.log";
          };
        }
      ];
    }
  ];
}
