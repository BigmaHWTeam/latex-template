# Makefile for LaTeX project

# The main LaTeX file. This can be overridden from the command line.
# Example: make all MAIN_FILE=homework1
MAIN_FILE ?= assignment

# The LaTeX compiler
LATEXMK = latexmk

# All tex files
TEX_FILES = $(wildcard *.tex)

# The default target
all: $(MAIN_FILE).pdf

# Rule to build the PDF
$(MAIN_FILE).pdf: $(TEX_FILES)
	$(LATEXMK) $(MAIN_FILE)

# Clean up generated files
clean:
	rm -rf build *.aux *.bbl *.bcf *.blg *.dvi *.fdb_latexmk *.fls *.log *.out *.pdf *.ps *.run.xml

.PHONY: all clean
