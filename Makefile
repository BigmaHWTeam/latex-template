# Makefile for LaTeX project

# The main LaTeX file
MAIN = assignment

# The LaTeX compiler
LATEXMK = latexmk

# All tex files
TEX_FILES = $(wildcard *.tex)

# The default target
all: $(MAIN).pdf

# Rule to build the PDF
$(MAIN).pdf: $(TEX_FILES)
	$(LATEXMK) $(MAIN)

# Clean up generated files
clean:
	rm -f *.aux *.bbl *.bcf *.blg *.dvi *.fdb_latexmk *.fls *.log *.out *.pdf *.ps *.run.xml

.PHONY: all clean
