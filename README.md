# LaTeX Homework Template

A LaTeX template for homework assignments, built around numbered `problem` /
`subproblem` boxes that break cleanly across pages.

## File Structure

- `assignment.tex`: Main file. Holds the document metadata (name, class,
  assignment, date, keywords) and includes the problem files. Renameable.
- `preamble.tex`: `\usepackage` commands and package configuration.
- `format.tex`: The `problem` and `subproblem` environments, their equation
  numbering, and the page-break continuation notes.
- `header.tex`: Title block, page header, and footer.
- `problem1.tex`: Example problem. Add `problem2.tex`, etc. and `\input` them.
- `Makefile`: Build, lint, format, and watch targets.
- `.latexmkrc`: latexmk configuration. Sends all output to `build/`.
- `.chktexrc` / `.latexindent.yaml`: Linter and formatter configuration.
- `.github/workflows/build.yml`: CI build via the repo's own flake.

## Setup

The flake provides texlive, latexmk, pandoc, chktex, and latexindent:

```bash
nix develop        # or `direnv allow`, via .envrc
```

## Usage

1. **Set the metadata** at the top of `assignment.tex` (`\myname`,
   `\classname`, `\assignment`, `\assigndate`, `\keywords`). These feed the
   title block, the page header, and the PDF metadata.

2. **Write problems** using the `problem` and `subproblem` environments:

   ```latex
   \begin{problem}{}{}
     Equations here are numbered (1.1), (1.2), ...
     \begin{subproblem}{}{part-a}
       And here (1.a.1), (1.a.2), ...
     \end{subproblem}
   \end{problem}
   ```

   Label a box with its **third** argument, not `\label`, and reference it as
   `\cref{problem:part-a}` or `\cref{subproblem:part-a}`. A `\label` inside the
   body records an empty number, because tcolorbox does not set
   `\@currentlabel` there.

3. **Renaming the main file** needs no configuration. The Makefile detects
   `assignment.tex`, then `hw*.tex`, then `*-hw*.tex`, and CI globs
   `build/*.pdf`. Override explicitly with `make MAIN_FILE=homework1`.

## Building

```bash
make            # build build/<name>.pdf
make watch      # continuous rebuild and preview (latexmk -pvc)
make lint       # chktex
make format     # rewrite sources with latexindent (review the diff)
make clean
make FORMAT=docx
```

`make FORMAT=docx` is a rough draft only. pandoc cannot see inside the
tcolorbox environments, so the problem boxes, their numbering, and display math
inside them are **dropped from the .docx**. Never submit it unchecked.

## Layout note

`geometry` is loaded with `includeheadfoot` so the 3-line page header stays
inside the 1in margin instead of landing in a printer's unprintable edge. The
cost is body height (`textheight` 564pt rather than 650pt). To reclaim it,
shorten the header to one line and drop `headheight` to 14pt, or use
`margin=0.75in`.

## CI/CD

`.github/workflows/build.yml` builds the PDF on every push and tag using
`nix develop --command make`, so CI and local builds use identical texlive.
Tagged pushes create a release with the PDF attached.

Renovate keeps `flake.lock` and the action versions current. `ignoreTests` is
`false`, so a toolchain bump that breaks compilation will not automerge.

> **Important:** CI needs "Read and Write permissions" for workflows, under
> `Settings > Actions > General > Workflow permissions`.
