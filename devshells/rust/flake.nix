{
  description = "Rust dev env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # toolchain
            cargo
            rustc
            rust-analyzer
            rustfmt
            clippy

            # editor
            pkgs-unstable.jetbrains.rust-rover
          ];

          shellHook = ''
            rust-rover > /dev/null 2>&1 &
            echo "Rust dev shell loaded"
          '';
        };
      }
    );
}
