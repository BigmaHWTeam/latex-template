# Build PDF directly via pdflatex.
$pdf_mode = 1;

# --shell-escape is deliberately absent: nothing in this template needs it, it
# lets any .tex you paste in run arbitrary shell, and it is disabled on
# Overleaf and most CI images. Add it back per-engine only if you adopt minted
# or pgfplots externalization.
$lualatex = 'lualatex -interaction=nonstopmode %O %S';
$xelatex  = 'xelatex -interaction=nonstopmode %O %S';
$pdflatex = 'pdflatex -interaction=nonstopmode %O %S';

# Output directory for generated files
$out_dir = 'build';
