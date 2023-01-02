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
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:5006
      '';
    };

    virtualHosts."caddy-metrics.flowerbox.house" = {
      hostName = "caddy-metrics.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        metrics /metrics
      '';
    };

    virtualHosts."davidwilemski.com" = {
      hostName = "davidwilemski.com";
      listenAddresses = [ "206.55.186.217" ];
      extraConfig = ''
        redir https://www.davidwilemski.com{uri}
      '';
    };

    virtualHosts."o.davidwilemski.com" = {
      hostName = "o.davidwilemski.com";
      listenAddresses = [ "206.55.186.217" ];
      extraConfig = ''
        encode zstd gzip
        reverse_proxy narya:3030
      '';
    };

    virtualHosts."dev.davidwilemski.com" = {
      hostName = "dev.davidwilemski.com";
      listenAddresses = [ "206.55.186.217" ];
      extraConfig = ''
        encode zstd gzip
        reverse_proxy narya:3030
      '';
    };

    virtualHosts."flowerboxarchive.com" = {
      hostName = "flowerboxarchive.com";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerboxarchive.com";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy jeod:8000
      '';
    };


    virtualHosts."gitea.flowerbox.house" = {
      hostName = "gitea.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:3000
      '';
    };

    virtualHosts."grafana.flowerbox.house" = {
      hostName = "grafana.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:3001
      '';
    };

    virtualHosts."home-assistant.flowerbox.house" = {
      hostName = "home-assistant.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy nenya:8123
      '';
    };

    virtualHosts."music.flowerbox.house" = {
      hostName = "music.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy jeod:8800
      '';
    };

    virtualHosts."prometheus.flowerbox.house" = {
      hostName = "prometheus.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy jeod:9090
      '';
    };

    virtualHosts."synology.flowerbox.house" = {
      hostName = "synology.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy jeod:5000
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
}
