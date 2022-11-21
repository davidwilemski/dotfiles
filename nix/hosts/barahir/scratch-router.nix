# collection of config that was attempted (mostly NFT firewall and some vlan stuff)
#
# Ran into issues with this approach (don't recall what, I think upnp?).

    # nftables = {
    #   enable = true;
    #   ruleset = ''
    #     table inet filter {
    #       # enable flow offloading for better throughput
    #       flowtable f {
    #         hook ingress priority 0;
    #         devices = { enp1s0, enp2s0 };
    #       }

    #       chain output {
    #         type filter hook output priority 100; policy accept;
    #       }

    #       chain input {
    #         type filter hook input priority filter; policy drop;

    #         # Allow trusted networks to access the router
    #         iifname {
    #           "enp2s0",
    #           "enp3s0",
    #           "enp4s0",
    #         } counter accept

    #         # # allow llmnr
    #         # udp dport llmnr accept
    #         # # allow mDNS
    #         # tcp dport mdns accept

    #         # # Accept mDNS for avahi reflection
    #         iifname {
    #             "enp2s0",
    #             "enp3s0",
    #             "enp4s0",
    #         } tcp dport { llmnr } counter accept
    #         iifname {
    #             "enp2s0",
    #             "enp3s0",
    #             "enp4s0",
    #         } udp dport { mdns, llmnr } counter accept

    #         # Allow returning traffic from wan and drop everthing else
    #         iifname "enp1s0" ct state { established, related } counter accept
    #         iifname "enp1s0" log drop

    #       }

    #       # Didn't work on initial test of making this system my router
    #       chain forward {
    #         type filter hook forward priority filter; policy drop;

    #         # enable flow offloading for better throughput
    #         ip protocol { tcp, udp } flow offload @f

    #         # Allow trusted network WAN access
    #         iifname {
    #                 "enp2s0",
    #                 "enp3s0",
    #                 "enp4s0",
    #         } oifname {
    #                 "enp1s0",
    #         } counter accept comment "Allow trusted LAN to WAN"

    #         # Allow established WAN to return
    #         iifname {
    #                 "enp1s0",
    #         } oifname {
    #                 "enp2s0",
    #                 "enp3s0",
    #                 "enp4s0",
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
    #         oifname "enp1s0" masquerade
    #       }
    #     }
    #   '';
    # };
    #
    #
  # services.dhcpd4 = {
  #   enable = true;
  #   interfaces = [ "enp2s0" "enp4s0" ];
  #   extraConfig = ''
  #     option domain-name-servers 9.9.9.9, 1.1.1.1;
  #     option subnet-mask 255.255.255.0;

  #     subnet 10.12.48.0 netmask 255.255.255.0 {
  #       option broadcast-address 10.12.48.255;
  #       option routers 10.12.48.1;
  #       interface enp2s0;
  #       range 10.12.48.100 10.12.48.254;
  #     }

  #     subnet 10.12.49.0 netmask 255.255.255.0 {
  #       option broadcast-address 10.12.48.255;
  #       option routers 10.12.49.1;
  #       interface enp3s0;
  #       range 10.12.49.100 10.12.49.254;
  #     }

  #     subnet 10.12.50.0 netmask 255.255.255.0 {
  #       option broadcast-address 10.12.48.255;
  #       option routers 10.12.50.1;
  #       interface enp4s0;
  #       range 10.12.50.100 10.12.50.254;
  #     }

  #     # subnet 10.12.60.0 netmask 255.255.255.0 {
  #     #   option broadcast-address 10.12.48.255;
  #     #   option routers 10.12.60.1;
  #     #   interface iot;
  #     #   range 10.12.60.100 10.12.60.254;
  #     # }
  #   '';
  # };
