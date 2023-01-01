{ pkgs, config, lib, ... }:

let
  inherit (lib)
    literalExpression
    mdDoc
    mkEnableOption
    mkIf
    mkOption
    types
  ;
  inherit (lib.attrsets) optionalAttrs;

  customPkgs = import ../../../custom-packages.nix {};

  cfg = config.dtw.services.davidwilemski-com;

in
{
  options.dtw.services.davidwilemski-com = {
    enable = mkEnableOption (mdDoc "davidwilemski.com services");

    user = mkOption {
      default = "micropub";
      type = types.str;
      description = mdDoc ''
        User account under which the davidwilemski.com micropub-rs service runs.
        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the service starts.
        :::
      '';
    };

    group = mkOption {
      default = "micropub";
      type = types.str;
      description = mdDoc ''
        Group account under which the davidwilemski.com micropub-rs service runs.
        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the service starts.
        :::
      '';
    };

    package = mkOption {
      default = customPkgs.micropub-rs;
      defaultText = literalExpression "customPkgs.micropub-rs";
      type = types.package;
      description = mdDoc ''
        micropub-rs package to use.
      '';
    };

    blobjectStorePackage = mkOption {
      default = customPkgs.rustyblobjectstore;
      defaultText = literalExpression "customPkgs.rustyblobjectstore";
      type = types.package;
      description = mdDoc ''
       rustyblobjectstore package to use.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/micropub-rs";
      description = mdDoc ''
        The data directory for the micropub-rs server.
        ::: {.note}
        If left as the default value this directory will automatically be created
        before the server starts, otherwise you are responsible for ensuring
        the directory exists with appropriate ownership and permissions.
        :::
      '';
    };

    micropubDb = mkOption {
      type = types.str;
      default = "micropub.sqlite";
      description = mdDoc ''
        The sqlite filename in the dataDir that the micropub-rs server will use for the DATABASE_URL.
      '';
    };

    blobjectstoreDb = mkOption {
      type = types.str;
      default = "rustyblobjectstore.sqlite";
      description = mdDoc ''
        The sqlite filename in the dataDir that the rustyblobjectstore server will use for the DATABASE_URL.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services."davidwilemski.com-micropub-rs" = {
      after = [ "network.target" ];
      wants = [];

      wantedBy = [ "multi-user.target" ];

      environment = {
        RUST_LOG = "trace";
        DATABASE_URL = "${cfg.dataDir}/${cfg.micropubDb}";
        MICROPUB_RS_TEMPLATE_DIR = "${customPkgs.blue-penguin-theme}";
        MICROPUB_RS_MEDIA_ENDPOINT = "https://davidwilemski.com/media";
        # TODO expose nix config for this so the store and micropub server could be operated on separate machines.
        MICROPUB_RS_BLOBJECT_STORE_BASE_URI = "http://localhost:3031";
      };

      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/server";

        User = cfg.user;
        Group = cfg.group;

        ReadWriteDirectories = cfg.dataDir;
        StateDirectory = mkIf (cfg.dataDir == "/var/lib/micropub-rs") [ "micropub-rs" ];
      };
    };

    # TODO separate nix module for this
    systemd.services."davidwilemski.com-rustyblobjectstore" = {
      after = [ "network.target" ];
      wants = [ "davidwilemski.com-micropub-rs.target" ];

      wantedBy = [ "multi-user.target" ];

      environment = {
        RUST_LOG = "info";
        DATABASE_URL = "${cfg.dataDir}/${cfg.blobjectstoreDb}";
      };

      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.blobjectStorePackage}/bin/rustyblobjectstore";

        User = cfg.user;
        Group = cfg.group;

        ReadWriteDirectories = cfg.dataDir;
        StateDirectory = mkIf (cfg.dataDir == "/var/lib/micropub-rs") [ "micropub-rs" ];
      };
    };

    users.users = optionalAttrs (cfg.user == "micropub") {
      micropub = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = optionalAttrs (cfg.group == "micropub") {
      micropub = {};
    };
  };
}
