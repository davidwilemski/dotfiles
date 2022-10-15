{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../common
    ../../common/services/sendzfssnapshot
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.kernelPackages = pkgs.linuxPackages_5_15;

  security.sudo.wheelNeedsPassword = false;

  # let's make this a router
  # https://francis.begyn.be/blog/nixos-home-router
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
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
      enp3s0.ipv4.addresses = [{
          address = "10.12.49.1";
          prefixLength = 24;
      }];
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

    # nat.enable = true;
    # nat.externalInterface = "enp1s0";
    # nat.internalInterfaces = [ "enp2s0" "enp4s0" ];
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          # enable flow offloading for better throughput
          flowtable f {
            hook ingress priority 0;
            devices = { enp1s0, enp2s0 };
          }

          chain output {
            type filter hook output priority 100; policy accept;
          }

          chain input {
            type filter hook input priority filter; policy drop;

            # Allow trusted networks to access the router
            iifname {
              "enp2s0",
              "enp3s0",
              "enp4s0",
            } counter accept

            # # allow llmnr
            # udp dport llmnr accept
            # # allow mDNS
            # tcp dport mdns accept

            # # Accept mDNS for avahi reflection
            iifname {
                "enp2s0",
                "enp3s0",
                "enp4s0",
            } tcp dport { llmnr } counter accept
            iifname {
                "enp2s0",
                "enp3s0",
                "enp4s0",
            } udp dport { mdns, llmnr } counter accept

            # Allow returning traffic from wan and drop everthing else
            iifname "enp1s0" ct state { established, related } counter accept
            iifname "enp1s0" log drop

          }

          # Didn't work on initial test of making this system my router
          chain forward {
            type filter hook forward priority filter; policy drop;

            # enable flow offloading for better throughput
            ip protocol { tcp, udp } flow offload @f

            # Allow trusted network WAN access
            iifname {
                    "enp2s0",
                    "enp3s0",
                    "enp4s0",
            } oifname {
                    "enp1s0",
            } counter accept comment "Allow trusted LAN to WAN"

            # Allow established WAN to return
            iifname {
                    "enp1s0",
            } oifname {
                    "enp2s0",
                    "enp3s0",
                    "enp4s0",
            } ct state established,related counter accept comment "Allow established back to LANs"
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook output priority filter; policy accept;
          }

          # Setup NAT masquerading on the wan interface
          chain postrouting {
            type nat hook postrouting priority filter; policy accept;
            oifname "enp1s0" masquerade
          }
        }
      '';
    };
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "enp2s0" "enp4s0" ];
    extraConfig = ''
      option domain-name-servers 9.9.9.9, 1.1.1.1;
      option subnet-mask 255.255.255.0;

      subnet 10.12.48.0 netmask 255.255.255.0 {
        option broadcast-address 10.12.48.255;
        option routers 10.12.48.1;
        interface enp2s0;
        range 10.12.48.100 10.12.48.254;
      }

      subnet 10.12.49.0 netmask 255.255.255.0 {
        option broadcast-address 10.12.48.255;
        option routers 10.12.49.1;
        interface enp3s0;
        range 10.12.49.100 10.12.49.254;
      }

      subnet 10.12.50.0 netmask 255.255.255.0 {
        option broadcast-address 10.12.48.255;
        option routers 10.12.50.1;
        interface enp4s0;
        range 10.12.50.100 10.12.50.254;
      }

      # subnet 10.12.60.0 netmask 255.255.255.0 {
      #   option broadcast-address 10.12.48.255;
      #   option routers 10.12.60.1;
      #   interface iot;
      #   range 10.12.60.100 10.12.60.254;
      # }
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

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "barahir";

  environment.systemPackages = with pkgs; [ wget vim zfs ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  services.tailscale.enable = true;
  # virtualisation.docker.enable = true;

  dtw.promtail = {
    enable = true;
  };

  services.openssh.enable = true;
  users.mutableUsers = false;

  system.stateVersion = "21.11";
}
