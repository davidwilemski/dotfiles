{ config, pkgs, lib, ... }: {
  systemd.services.install = {
    description = "Bootstrap a NixOS installation";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "polkit.service" ];
    path = [ "/run/current-system/sw/" ];
    script = with pkgs; ''
        echo 'journalctl -fb -n100 -uinstall' >>~nixos/.bash_history
        set -eux
        # delete all existing partitions
        sfdisk --delete /dev/sda
        # partitioning
        parted -s /dev/sda -- mklabel gpt
        parted -s /dev/sda -- mkpart primary 512MiB -4GiB
        parted -s /dev/sda -- mkpart primary linux-swap -4GiB 100%
        parted -s /dev/sda -- mkpart ESP fat32 1MiB 512MiB
        parted -s /dev/sda -- set 3 esp on
        sync
        # zfs
        zpool create -f -O xattr=sa -O acltype=posixacl -O compression=zstd -O atime=off rpool /dev/sda1
        zfs create -o mountpoint=none rpool/local
        zfs create -o mountpoint=legacy rpool/local/nix
        zfs create -o mountpoint=none rpool/safe
        zfs create -o mountpoint=legacy rpool/safe/home
        zfs create -o mountpoint=legacy rpool/safe/root
        sync
        # swap
        mkswap /dev/sda2
        swapon /dev/sda2
        # ESP
        mkfs.vfat /dev/sda3
        # mounting
        mount -t zfs rpool/safe/root /mnt
        mkdir /mnt/boot /mnt/etc /mnt/home /mnt/nix
        mount /dev/sda3 /mnt/boot
        mount -t zfs rpool/safe/home /mnt/home
        mount -t zfs rpool/local/nix /mnt/nix
        install -D ${./configuration.nix} /mnt/etc/nixos/configuration.nix
        install -D ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix
        sed -i -E 's/(\w*)#installer-only /\1/' /mnt/etc/nixos/*
        hostid="$(printf "00000000%x" "$(cksum /etc/machine-id | cut -d' ' -f1)" | tail -c8)"
        sed -i -E 's/facecafe/'$hostid'/' /mnt/etc/nixos/hardware-configuration.nix
        ${config.system.build.nixos-install}/bin/nixos-install \
          --system ${
            (import <nixpkgs/nixos/lib/eval-config.nix> {
              system = "x86_64-linux";
              modules = [ ./configuration.nix ./hardware-configuration.nix ];
            }).config.system.build.toplevel
          } \
          --no-root-passwd \
          --cores 0
        echo 'Shutting off...'
        ${systemd}/bin/shutdown now
      '';
    environment = config.nix.envVars // {
      inherit (config.environment.sessionVariables) NIX_PATH;
      HOME = "/root";
    };
    serviceConfig = { Type = "oneshot"; };
  };
}
