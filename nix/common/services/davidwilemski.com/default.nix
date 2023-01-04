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

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = mdDoc ''
        Object used to create a toml file to configure the micropub server.
      '';
    };

    serverConfig = mkOption {
      type = types.attrs;
      internal = true;
    };
  };

  config = mkIf cfg.enable {
    # apply values from structured options before extraConfig
    dtw.services.davidwilemski-com.serverConfig = lib.mkMerge [
      (mkIf (!lib.hasAttr "database_url" cfg.extraConfig) {
        database_url = "${cfg.dataDir}/${cfg.micropubDb}";
      })
      (mkIf (!lib.hasAttr "template_dir" cfg.extraConfig) {
        template_dir = customPkgs.blue-penguin-theme;
      })

      cfg.extraConfig
    ];

    systemd.services."davidwilemski.com-micropub-rs" = {
      after = [ "network.target" ];
      wants = [];

      wantedBy = [ "multi-user.target" ];

      environment = {
        RUST_LOG = "debug";
      };

      serviceConfig = {
        Type = "exec";
        ExecStart =
        let
          # construct config
          formatToml = pkgs.formats.toml {};
          siteConfig = formatToml.generate "davidwilemski_micropub_server.toml" cfg.serverConfig;
        in ''${cfg.package}/bin/server ${siteConfig}'';

        User = cfg.user;
        Group = cfg.group;

        WorkingDirectory = cfg.dataDir;
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

        WorkingDirectory = cfg.dataDir;
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
