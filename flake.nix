{
  description = "A devshell flake with latex, python, and assignment profiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
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
            pkgs.texlivePackages.latexmk
            pkgs.python3
            pkgs.python3Packages.pip
            pkgs.python3Packages.virtualenv
            pkgs.zstd
            (pkgs.texliveSmall.withPackages (
              ps:
                with ps; [
                  amsfonts
                  appendix
                  biblatex
                  csquotes
                  doublestroke
                  enumitem
                  esint
                  framed
                  pdfcol
                  physics
                  rsfs
                  tikzfill
                  tcolorbox
                  titlesec
                ]
            ))
          ];
          inputsFrom = [fhsEnvironment];
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
