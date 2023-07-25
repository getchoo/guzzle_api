{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.guzzle-api;
  inherit (lib) mkDefault mkEnableOption mkOption mkIf types;
in {
  options.services.guzzle-api = {
    enable = mkEnableOption "enable guzzle-api";
    url = mkOption {
      type = types.str;
      default = "";
      description = "url string for guzzle-api";
    };
    port = mkOption {
      type = types.str;
      default = "8080";
      description = "port for guzzle-api";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.guzzle-api-server;
      description = "package for guzzle-api wrapper";
    };
  };

  config.systemd.services = mkIf cfg.enable {
    guzzle-api = {
      enable = mkDefault true;
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      script = ''
        URL=${cfg.url} ${cfg.package}/bin/guzzle-api-server --host 0.0.0.0 --port "${cfg.port}"
      '';
      serviceConfig = mkDefault {
        Restart = "always";
        Type = "simple";
      };
    };
  };
}