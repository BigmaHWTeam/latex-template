# Makefile for LaTeX project

# The main LaTeX file. This can be overridden from the command line.
# Example: make all MAIN_FILE=homework1
# Automatically detect MAIN_FILE if not specified
ifeq ($(origin MAIN_FILE), undefined)
    # Try assignment.tex first
    _DETECTED_MAIN_FILE := $(basename $(wildcard assignment.tex))

    # If not found, try hw*.tex
    ifeq ($(_DETECTED_MAIN_FILE),)
        _DETECTED_MAIN_FILE := $(basename $(firstword $(wildcard hw*.tex)))
    endif

    # If not found, try *-hw*.tex
    ifeq ($(_DETECTED_MAIN_FILE),)
        _DETECTED_MAIN_FILE := $(basename $(firstword $(wildcard *-hw*.tex)))
    endif

    # Fallback if no specific file is found
    ifeq ($(_DETECTED_MAIN_FILE),)
        MAIN_FILE := assignment
    else
        MAIN_FILE := $(_DETECTED_MAIN_FILE)
    endif
endif

# Output PDF name (without extension). Defaults to MAIN_FILE.
BUILD_NAME ?= $(MAIN_FILE)

# The LaTeX compiler
LATEXMK = latexmk

# The document converter (for DOCX output)
PANDOC = pandoc

# Output format: pdf or docx. Edit this value directly to change the default.
FORMAT ?= pdf

# All tex files
TEX_FILES = $(wildcard *.tex)

# The default target
all: build/$(BUILD_NAME).$(FORMAT)

# Rule to build the PDF.
#
# FORCE, not $(TEX_FILES), as the prerequisite: latexmk already tracks every
# input it actually read via build/*.fls, including images, .bib files and
# anything under images/ or ampl_output/. A *.tex-only prerequisite list made
# make skip the build entirely when only a figure changed, silently leaving a
# stale PDF. Deciding twice is worse than deciding once, so latexmk decides.
build/$(BUILD_NAME).pdf: FORCE
	$(LATEXMK) -jobname=$(BUILD_NAME) $(MAIN_FILE)

# Continuous preview: rebuilds and refreshes the viewer on every save. Prefer
# this over texlab's onSave, which fires a full make on each keystroke-save.
watch:
	$(LATEXMK) -pvc -jobname=$(BUILD_NAME) $(MAIN_FILE)

# Rule to build the Word document.
#
# pandoc cannot see inside the tcolorbox problem/subproblem environments, so
# this output drops the problem boxes, their numbering, and display math within
# them. It is a rough draft for people who demand .docx, never a submission.
build/$(BUILD_NAME).docx: FORCE
	mkdir -p build
	@echo "warning: docx conversion drops tcolorbox content (problem boxes," >&2
	@echo "         numbering, and math inside them). Check the output." >&2
	$(PANDOC) $(MAIN_FILE).tex -o build/$(BUILD_NAME).docx

# Lint the sources. chktex is the correctness linter and gates here; it reads
# .chktexrc and currently passes clean.
#
# latexindent is deliberately NOT part of lint. It refuses to indent inside the
# tcbtheorem problem/subproblem environments and wants to reflow the
# hand-wrapped tcolorbox key lists in format.tex, so gating on it would leave
# lint permanently red over pure cosmetics. Run `make format` when you want it.
lint:
	chktex --quiet --inputfiles=0 $(TEX_FILES)

# Rewrite the sources in place with latexindent's formatting. Review the diff:
# it will un-indent problem bodies. See .latexindent.yaml.
format:
	latexindent -l=.latexindent.yaml --overwrite --silent $(TEX_FILES)

# Clean up generated files
clean:
	rm -rf build *.aux *.bbl *.bcf *.blg *.dvi *.fdb_latexmk *.fls *.log *.out *.ps *.run.xml

FORCE:

.PHONY: all clean lint format watch FORCE
