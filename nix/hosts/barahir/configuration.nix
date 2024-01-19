{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./caddy

    ../../common
    ../../common/services/sendzfssnapshot
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 15;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  security.sudo.wheelNeedsPassword = false;

  # let's make this a router
  # https://francis.begyn.be/blog/nixos-home-router
  # https://skogsbrus.xyz/blog/2022/06/12/router/
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  networking = {
    useDHCP = false;
    # vlans = {
    #   iot = {
    #     id = 30;
    #     interface = "enp3s0";
    #   };
    # };

    interfaces = {
      # WAN
      enp1s0.useDHCP = true;

      # Main LAN
      enp2s0.useDHCP = false;
      # other LAN
      enp3s0.useDHCP = false;
      enp4s0.useDHCP = false;

      # Main LAN
      enp2s0.ipv4.addresses = [{
          address = "10.12.48.1";
          prefixLength = 24;
      }];
      # IOT devices
      # XXX - trying to disable internet access for these
      enp3s0.ipv4.addresses = [{
          address = "10.12.49.1";
          prefixLength = 24;
      }];
      # Guest network: firewall partially locked down for internal and external
      # access
      enp4s0.ipv4.addresses = [{
          address = "10.12.50.1";
          prefixLength = 24;
      }];

      # Handle the VLANs
      # wan.useDHCP = true;
      # iot = {
      #   ipv4.addresses = [{
      #     address = "10.12.60.1";
      #     prefixLength = 24;
      #   }];
      # };
    };

    nat = {
      enable = true;
      externalInterface = "enp1s0";
      internalInterfaces = [ "enp2s0" "enp4s0" ];
    };

    # https://skogsbrus.xyz/blog/2022/06/12/router/#firewall
    firewall = {
      enable = true;
      trustedInterfaces = [ "enp2s0" "tailscale0" ];

      interfaces = {
        # ingress: wan to internal
        enp1s0 = {
          allowedTCPPorts = [ 80 443 ];
          allowedUDPPorts = [ ];
        };

        # iot to wan
        enp3s0 = {
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
        };

        # guest to wan
        # https://serverfault.com/a/424226
        enp4s0 = {
          allowedTCPPorts = [
            # DNS
            53

            # HTTP(S)
            80
            443
            110

            # Email (pop3, pop3s)
            995
            114
            # Email (imap, imaps)
            993
            # Email (SMTP Submission RFC 6409)
            587
          ];
          allowedUDPPorts = [
            # DNS
            53

            # DHCP
            67
            68

            # NTP
            123
          ];
        };
      };


    };
  };

  # Run a DNS-over-HTTPS proxy to point the dnsmasq resolver at
  services.https-dns-proxy = {
    enable = true;
    # Defaults to quad9 but I'm gonna be explicit
    provider.kind = "quad9";
    extraArgs = [ "-vv" ];
  };

  services.resolved.enable = false;
  services.dnsmasq = {
    enable = true;
    # this is the https-dns-proxy server
    servers = [ "127.0.0.1#5053" ];
    extraConfig = ''
      cache-size=2500

      domain-needed
      dhcp-authoritative
      interface=enp2s0
      interface=enp3s0
      interface=enp4s0
      dhcp-range=internal,10.12.48.50,10.12.48.250,255.255.255.0,24h
      dhcp-range=iot,10.12.48.11,10.12.48.250,255.255.255.0,24h
      dhcp-range=guest,10.12.48.11,10.12.48.250,255.255.255.0,24h

      # jeod
      dhcp-host=00:11:32:cd:c8:75,10.12.48.2

      # vilya 
      dhcp-host=b0:4f:13:07:39:75,10.12.48.3
      # nenya
      dhcp-host=6c:2b:59:f3:46:57,10.12.48.4
      # narya
      dhcp-host=b8:85:84:b6:c9:ff,10.12.48.5

      # Broadlink remotes (need static ip for home assistant)
      # TODO see if I can move these to the iot subnet
      # RM4-Pro-Universal-Remote-Kitchen
      dhcp-host=a0:43:b0:55:0b:06,10.12.48.20
      # RM4-Universal-Remote (bedroom)
      dhcp-host=a0:43:b0:2c:9B:d4,10.12.48.21
      # RM4-Universal-Remote-office
      dhcp-host=a0:43:b0:2c:d0:47,10.12.48.22
    '';
  };

  services.avahi = {
    enable = true;
    reflector = true;
    interfaces = [
      # Not wan (enp1s0)
      "enp2s0"
      "enp4s0"
    ];
  };

  networking.hostName = "barahir";

  environment.systemPackages = with pkgs; [ wget vim zfs ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  services.tailscale.enable = true;
  # virtualisation.docker.enable = true;

  services.prometheus.exporters.dnsmasq = {
    enable = true;
    leasesPath = "/var/lib/dnsmasq/dnsmasq.leases";
  };

  dtw.promtail = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    # We explicitly configure firewall ports above
    openFirewall = false;
  };

  users.mutableUsers = false;

  system.stateVersion = "21.11";
}
