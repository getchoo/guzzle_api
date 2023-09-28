{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    pkgs' = lib.fix (final: self.overlays.default final pkgs);
  in {
    packages = {
      inherit (pkgs') guzzle-api guzzle-api-server;
      default = pkgs'.guzzle-api-server;
    };
  };

  flake.overlays.default = final: prev:
    with prev.python311Packages; {
      guzzle-api = callPackage ./derivation.nix {inherit self;};
      guzzle-api-server = callPackage ./server.nix {inherit (final) guzzle-api;};
    };
}
