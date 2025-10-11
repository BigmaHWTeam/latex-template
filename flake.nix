{
  description = "A devshell flake with latex, python, and assignment profiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fhsEnvironment = pkgs.buildFHSEnv {
          name = "fhs-env";
          targetPkgs = pkgs: [
            pkgs.stdenv.cc.cc.lib
            pkgs.libz
          ];
        };
        devShell = pkgs.mkShell {
          packages = [
            pkgs.python3
            pkgs.python3Packages.pip
            pkgs.python3Packages.virtualenv
            pkgs.zstd
            pkgs.texlive.combined.scheme-full
          ];
          inputsFrom = [ fhsEnvironment ];
          shellHook = ''
            if [ ! -d ".venv" ]; then
              echo "Creating virtual environment..."
              python -m venv .venv
            fi
            source .venv/bin/activate
            pip install -r requirements.txt
          '';
        };
      in {
        devShells = {
          default = devShell;
        };
      }
    );
}
