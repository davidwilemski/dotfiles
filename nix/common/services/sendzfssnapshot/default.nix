{ pkgs, config, ... }:

{
  systemd.services.sendzfssnapshot = {
    after = [];
    wants = [];
    serviceConfig.Type = "oneshot";
    startAt = ''00:12:30'';

    script = ''
      function snapshot_to_filename {
          echo -n "''$(${pkgs.inetutils}/bin/hostname)-''$(echo $1 | ${pkgs.gnused}/bin/sed 's#/#-#g')"
      }

      # Only back up daily snapshots
      snapshots=''$(${pkgs.zfs}/bin/zfs list -H -t snapshot -o name | ${pkgs.gawk}/bin/awk '/daily/')

      # TODO - if disk space becomes a concern, send incremental snapshots
      # instead of full backups (e.g. once a month send full snapshot with
      # incremental for rest of month)
      for snapshot in $snapshots
      do
      echo "sending $snapshot"
      ${pkgs.zfs}/bin/zfs send $snapshot |
        ${pkgs.zstd}/bin/zstd |
        ${pkgs.openssh}/bin/ssh dtw@jeod "cat > /volume1/zfs_snapshots/$(${pkgs.inetutils}/bin/hostname)/$(snapshot_to_filename $snapshot).zst"
      done

      # TODO - delete older backups
      # $remotesnapshotfiles=$(${pkgs.openssh}/bin/ssh jeod 'ls /volume1/zfs_snapshots/vilya/' | grep daily)
    '';
  };
}
