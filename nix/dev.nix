{
  inputs,
  self,
  withSystem,
  ...
}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit = {
      settings.hooks = {
        isort.enable = true;
        pylint.enable = true;
        yapf = {
          enable = true;
          name = "yapf";
          entry = "${pkgs.python311Packages.yapf}/bin/yapf -i";
          types = ["file" "python"];
        };
      };
    };

    devShells.default = pkgs.mkShell {
      shellHook = config.pre-commit.installationScript;
      packages = [
        (pkgs.python311.withPackages (p: with p; [isort yapf pylint]))
      ];
    };
  };

  flake.tests.x86_64-linux.module = withSystem "x86_64-linux" ({pkgs, ...}:
    (import (inputs.nixpkgs + "/nixos/lib") {}).runTest {
      imports = [./vm.nix];

      hostPkgs = pkgs;

      _module.args = {inherit self;};
    });
}
