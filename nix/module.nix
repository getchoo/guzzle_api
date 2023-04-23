{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.guzzle-api;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.services.guzzle-api.enable = mkEnableOption "enable guzzle-api";

  config.systemd.services.guzzle-api = mkIf cfg.enable {
    guzzle-api = {
      enable = mkDefault true;
      ports = mkDefault ["8080:80"];
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      script = ''
        ${pkgs.guzzle-api-server} --host 0.0.0.0 --port 8000
      '';
      serviceConfig = mkDefault {
        Restart = "always";
        Type = "simple";
      };
    };
  };
}
