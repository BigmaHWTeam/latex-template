# Build PDF directly via pdflatex.
$pdf_mode = 1;

# -synctex=1 emits build/<name>.synctex.gz, which is what lets the editor jump
# to a spot in the PDF and Okular jump back to the source line.
#
# --shell-escape is deliberately absent: nothing in this template needs it, it
# lets any .tex you paste in run arbitrary shell, and it is disabled on
# Overleaf and most CI images. Add it back per-engine only if you adopt minted
# or pgfplots externalization.
$lualatex = 'lualatex -synctex=1 -interaction=nonstopmode %O %S';
$xelatex  = 'xelatex -synctex=1 -interaction=nonstopmode %O %S';
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode %O %S';

# Output directory for generated files
$out_dir = 'build';
