{self, ...}: {
  name = "guzzle_api-test";

  nodes.machine = _: {
    imports = [self.nixosModules.default];

    boot.loader.grub.enable = true;
    virtualisation = {
      memorySize = 2048;
      writableStore = true;
    };

    services = {
      nginx = {
        enable = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };

      guzzle-api = {
        enable = true;
        domain = "test.com";
        listen = {
          host = "0.0.0.0";
          port = 8080;
        };
        nginx = {};
      };
    };
  };

  testScript = _: ''
    machine.start()
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("guzzle-api.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl 0.0.0.0:8080/get_random_teawie | grep url")
  '';
}
