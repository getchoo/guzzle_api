{
  description = "silly little api";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
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
    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      inherit (pkgs) mkShell;
    in {
      default = mkShell {
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
