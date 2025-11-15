# Use pdflatex
$pdf_mode = 1;
$lualatex = 'lualatex --shell-escape -interaction=nonstopmode %O %S';
$xelatex = 'xelatex --shell-escape -interaction=nonstopmode %O %S';
$pdflatex = 'pdflatex --shell-escape -interaction=nonstopmode %O %S';

# Output directory for generated files
$out_dir = 'build';

# Force latexmk to run even if source files are unchanged
$always_run = 1;
