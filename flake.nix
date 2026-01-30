{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    tern-src.url = "github:yuuhikaze/tern";
  };

  outputs = { self, nixpkgs, flake-utils, tern-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        tern-core = tern-src.packages.${system}.tern-core;
      in {
        # Export docs devshell for external use
        devShells.docs = import ./devshells/docs.nix {
          inherit pkgs tern-core;
          resources-root = self;
        };
      });
}
