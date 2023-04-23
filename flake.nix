{
  description = "silly little api";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
  }: let
    version = self.lastModifiedDate;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
    nixpkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      });

    packageFn = pkgs: let
      inherit (pkgs) callPackage;
    in {
      guzzle-api = callPackage ./nix {inherit version;};
      guzzle-api-server = callPackage ./nix/server.nix {};
    };
  in {
    checks = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
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
    });

    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      inherit (pkgs) mkShell;
    in {
      default = mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = with pkgs.python311Packages; [
          python
          fastapi
          httpx
          pydantic
          pylint
          toml
          uvicorn
          yapf
        ];
      };
    });

    nixosModules.guzzle_api = import ./nix/module.nix;

    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {inherit (pkgs) guzzle-api guzzle-api-server;});

    overlays.default = final: _: packageFn final;
  };
}
