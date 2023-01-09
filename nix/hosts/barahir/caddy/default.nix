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
    requiredBy = [
      "acme-flowerbox.house.service"
    ];
    before = [
      "acme-flowerbox.house.service"
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
