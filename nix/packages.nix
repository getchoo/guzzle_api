{self, ...}: let
  version = builtins.substring 0 8 self.lastModifiedDate or "dirty";
  commonArgs = {inherit self version;};
in {
  perSystem = {pkgs, ...}: {
    packages = rec {
      guzzle-api = pkgs.python311Packages.callPackage ./derivation.nix commonArgs;
      guzzle-api-server = pkgs.python311Packages.callPackage ./server.nix {inherit guzzle-api;};
      default = guzzle-api;
    };
  };

  flake.overlays.default = final: prev: {
    python = prev.python.override {
      packageOverrides = _: prev': {
        guzzle-api = prev'.callPackage ./derivation.nix commonArgs;
      };
    };

    pythonPackages = final.python.pkgs;

    guzzle-api = final.pythonPackages.callPackage ./derivation.nix commonArgs;
    guzzle-api-server = final.pythonPackages.callPackage ./server.nix {};
  };
}
