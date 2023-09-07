self: {
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: let
  cfg = config.services.guzzle-api;
  inherit
    (lib)
    literalExpression
    mkDefault
    mdDoc
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;

  proto = "http${lib.optionalString cfg.nginx.addSSL "s"}";

  hostPortSubmodule = {
    options = {
      host = mkOption {
        description = mdDoc "the hostname";
        type = types.str;
      };

      port = mkOption {
        description = mdDoc "the port";
        type = types.port;
      };
    };
  };
in {
  options.services.guzzle-api = {
    enable = mkEnableOption "guzzle-api";

    listen = mkOption {
      description = mdDoc "address and port to listen to";
      type = types.submodule hostPortSubmodule;
      default = {
        host = "localhost";
        port = 7240;
      };
      defaultText = literalExpression ''
        {
          address = "localhost";
          port = 7240;
        }
      '';
    };

    domain = mkOption {
      description = mdDoc "FQDN for guzzle_api endpoint";
      type = types.str;
    };

    nginx = mkOption {
      description = mdDoc ''
        With this option, you can customize an nginx virtual host which already has sensible defaults for Dolibarr.
        Set to {} if you do not need any customization to the virtual host.
        If enabled, then by default, the {option}`serverName` is
        `''${domain}`,
        If this is set to null (the default), no nginx virtualHost will be configured.
      '';

      type = types.nullOr (types.submodule (
        import (modulesPath + "/services/web-servers/nginx/vhost-options.nix") {inherit config lib;}
      ));

      default = null;
      example = literalExpression ''
        {
          enableACME = true;
        	forceSSL = true;
        }
      '';
    };

    package = mkPackageOption self.packages.${pkgs.stdenv.hostPlatform.system} "guzzle-api-server" {};
  };

  config = mkIf cfg.enable {
    systemd.services.guzzle-api = {
      enable = mkDefault true;
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      script = ''
        URL="${proto}://${cfg.domain}" ${cfg.package}/bin/guzzle-api-server --host ${cfg.listen.host} --port ${toString cfg.listen.port}
      '';
      serviceConfig = mkDefault {
        Type = "simple";
        Restart = "always";

        # hardening
        DynamicUser = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        RestrictNamespaces = "uts ipc pid user cgroup";
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateDevices = true;
        RestrictSUIDSGID = true;
      };
    };

    services.nginx = mkIf (cfg.nginx != null) {
      enable = true;
      virtualHosts."${cfg.domain}" = mkMerge [
        {
          locations."/" = {
            proxyPass = "http://${cfg.listen.host}:${toString cfg.listen.port}";
          };
        }
        cfg.nginx
      ];
    };
  };
}
