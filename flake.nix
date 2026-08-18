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
          # Only stand up a virtualenv when there is something to install into
          # it. mkShell concatenates the shellHooks of everything in
          # inputsFrom, so the unconditional version rebuilt a venv on every
          # `nix develop` even in a repo whose requirements.txt is empty.
          shellHook = ''
            if [ -s "requirements.txt" ]; then
              if [ ! -d ".venv" ] || ! .venv/bin/python --version &>/dev/null; then
                virtualenv .venv
              fi
              source .venv/bin/activate
              pip install -r requirements.txt
            fi
          '';
          env = fhsEnvironment;
        };
        latex = pkgs.mkShell {
          packages = [
            pkgs.ghostscript
            pkgs.pandoc
            pkgs.pre-commit
            pkgs.yq-go
            pkgs.zstd
            pkgs.texlivePackages.latexmk
            (pkgs.texliveSmall.withPackages (
              ps:
                with ps; [
                  amsfonts
                  appendix
                  biblatex
                  chktex
                  cleveref
                  csquotes
                  doublestroke
                  enumitem
                  esint
                  lastpage
                  latexindent
                  mathtools
                  microtype
                  pdfcol
                  physics
                  rsfs
                  tikzfill
                  tcolorbox
                  titlesec
                ]
            ))
          ];
          # Install the git hook on shell entry so `make lint` runs before a
          # commit without anyone having to remember `pre-commit install`.
          # Guarded on .git so this is a no-op in an unversioned copy.
          shellHook = ''
            if [ -d .git ] && [ -f .pre-commit-config.yaml ] \
              && [ ! -f .git/hooks/pre-commit ]; then
              pre-commit install >/dev/null 2>&1 || true
            fi
          '';
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
