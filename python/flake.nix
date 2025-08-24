{
  description = "Python development shell";

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
            # Python lang
            python313Full

            # Notebooks
            python313Packages.jupyter
            python313Packages.jupyterlab
            python313Packages.notebook

            # Misc Dependencies
            python313Packages.pyzmq
            stdenv.cc.cc.lib
            zlib

            # editor
            pkgs-unstable.jetbrains.pycharm-professional
          ];

          shellHook = ''
            export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
            pycharm-professional > /dev/null 2>&1 &
            echo "Python dev shell loaded"
          '';
        };
      }
    );
}
