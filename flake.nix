{
  description = "silly little api";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pre-commit = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = {
    parts,
    pre-commit,
    self,
    ...
  } @ inputs:
    parts.lib.mkFlake {inherit inputs;} {
      imports = [
        pre-commit.flakeModule
        ./nix/dev.nix
        ./nix/packages.nix
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {pkgs, ...}: {formatter = pkgs.alejandra;};

      flake.nixosModules.default = import ./nix/module.nix self;
    };
}
