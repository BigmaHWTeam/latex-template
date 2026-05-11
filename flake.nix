{
  description = "A devshell flake with latex, python, and assignment profiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        fhsEnvironment = {
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
            pkgs.libz
          ];
        };
        python = pkgs.mkShell {
          packages = [
            pkgs.python3
            pkgs.python3Packages.pip
            pkgs.imagemagick
            pkgs.python3Packages.virtualenv
          ];
          shellHook = ''
            if [ ! -d ".venv" ] || ! .venv/bin/python --version &>/dev/null; then
              virtualenv .venv
            fi
            source .venv/bin/activate
            if [ -s "requirements.txt" ]; then
              pip install -r requirements.txt
            fi
          '';
          env = fhsEnvironment;
        };
        latex = pkgs.mkShell {
          packages = [
            pkgs.ghostscript
            pkgs.pandoc
            pkgs.yq-go
            pkgs.zstd
            pkgs.texlivePackages.latexmk
            (pkgs.texliveSmall.withPackages (
              ps:
                with ps; [
                  amsfonts
                  appendix
                  biblatex
                  cleveref
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
        };
      in {
        devShells = {
          python = python;
          latex = latex;
          default = pkgs.mkShell {
            inputsFrom = [
              python
              latex
            ];
            env = fhsEnvironment;
          };
        };
      }
    );
}
