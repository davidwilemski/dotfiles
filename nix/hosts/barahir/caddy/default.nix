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

    virtualHosts."caddy-metrics.flowerbox.house" = {
      hostName = "caddy-metrics.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        metrics /metrics
      '';
    };

    virtualHosts."grafana.flowerbox.house" = {
      hostName = "grafana.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        reverse_proxy nenya:3001
      '';
    };

    virtualHosts."gitea.flowerbox.house" = {
      hostName = "gitea.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        reverse_proxy nenya:3000
      '';
    };

    virtualHosts."home-assistant.flowerbox.house" = {
      hostName = "home-assistant.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        reverse_proxy nenya:8123
      '';
    };

    virtualHosts."prometheus.flowerbox.house" = {
      hostName = "prometheus.flowerbox.house";
      listenAddresses = [ "100.99.34.64" ];
      useACMEHost = "flowerbox.house";
      extraConfig = ''
        reverse_proxy jeod:9090
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
  };

  config.systemd.services.dtw-dns-acme-namecheap-conf = {
    requiredBy = ["acme-flowerbox.house.service"];
    before = ["acme-flowerbox.house.service"];
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
