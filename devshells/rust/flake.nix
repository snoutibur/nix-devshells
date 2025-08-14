{
  description = "Rust dev env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
			cargo
			rustc
			rustup

			jetbrains.rust-rover
          ];

          shellHook = ''
            echo "Rust dev shell loaded"
            echo "rustup default stable to install toolchain"
          '';
        };
      });
}
