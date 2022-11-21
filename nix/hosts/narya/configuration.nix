{ config, pkgs, ... }:

{
  imports = [
  ];

  networking.hostName = "narya";

  users.motd = builtins.readFile ./motd;

  # let's make this a router
  # https://francis.begyn.be/blog/nixos-home-router
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
  };

  dtw.systemd-resolved.enable = true;
  networking = {
    useDHCP = false;
    # nameserver = [ <SOMETHING> ];

    vlans = {
      # wan = {
      #   id = 10;
      #   interface = "enp0s20f0u2c2";
      # };

      lan = {
        id = 20;
        interface = "enp1s0";
      };
    };

    interfaces = {
      enp0s20f0u2c2.useDHCP = true;
      enp1s0.useDHCP = false;
      enp1s0.ipv4.addresses = [{
          address = "10.12.48.1";
          prefixLength = 24;
      }];

      # Handle the VLANs
      # wan.useDHCP = true;
      # lan = {
      #   ipv4.addresses = [{
      #     address = "10.12.48.1";
      #     prefixLength = 24;
      #   }];
      # };
    };

    #nat.enable = false;
    nat.enable = true;
    # nat.externalInterface = "wan";
    nat.externalInterface = "enp0s20f0u2c2";
    nat.internalInterfaces = [ "enp1s0" ];

    firewall.enable = true;
    # nftables = {
    #   enable = true;
    #   ruleset = ''
    #     table inet filter {
    #       # enable flow offloading for better throughput
    #       flowtable f {
    #         hook ingress priority 0;
    #         # devices = { wan, lan };
    #         devices = { enp0s20f0u2c2, enp1s0};
    #       }

    #       chain output {
    #         type filter hook output priority 100; policy accept;
    #       }

    #       chain input {
    #         type filter hook input priority filter; policy drop;

    #         # Allow trusted networks to access the router
    #         iifname {
    #           "enp1s0",
    #         } counter accept

    #         # Allow returning traffic from wan and drop everthing else
    #         iifname "enp1s0" ct state { established, related } counter accept
    #         iifname "enp0s20f0u2c2" drop
    #       }

    #       chain forward {
    #         type filter hook forward priority filter; policy drop;

    #         # enable flow offloading for better throughput
    #         ip protocol { tcp, udp } flow offload @f

    #         # Allow trusted network WAN access
    #         iifname {
    #                 "enp1s0",
    #         } oifname {
    #                 "enp0s20f0u2c2",
    #         } counter accept comment "Allow trusted LAN to WAN"

    #         # Allow established WAN to return
    #         iifname {
    #                 "enp0s20f0u2c2",
    #         } oifname {
    #                 "enp1s0",
    #         } ct state established,related counter accept comment "Allow established back to LANs"
    #       }
    #     }

    #     table ip nat {
    #       chain prerouting {
    #         type nat hook output priority filter; policy accept;
    #       }

    #       # Setup NAT masquerading on the wan interface
    #       chain postrouting {
    #         type nat hook postrouting priority filter; policy accept;
    #         oifname "enp0s20f0u2c2" masquerade
    #       }
    #     }
    #   '';
    # };
  };

  services.dhcpd4 = {
    enable = true;
    #interfaces = [ "lan" ];
    interfaces = [ "enp1s0" ];
    extraConfig = ''
      option domain-name-servers 9.9.9.9, 1.1.1.1;
      option subnet-mask 255.255.255.0;

      subnet 10.12.48.0 netmask 255.255.255.0 {
        option broadcast-address 10.12.48.255;
        option routers 10.12.48.1;
        interface enp1s0;
        range 10.12.48.100 10.12.48.254;
      }
    '';
  };
}
