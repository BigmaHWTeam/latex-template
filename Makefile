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
# Edit this value directly, then run `make sync-ci` to propagate it to CI.
BUILD_NAME ?= $(MAIN_FILE)

# The LaTeX compiler
LATEXMK = latexmk

# All tex files
TEX_FILES = $(wildcard *.tex)

# The default target
all: build/$(BUILD_NAME).pdf

# Rule to build the PDF
build/$(BUILD_NAME).pdf: $(TEX_FILES)
	$(LATEXMK) -jobname=$(BUILD_NAME) $(MAIN_FILE)

# Clean up generated files
clean:
	rm -rf build *.aux *.bbl *.bcf *.blg *.dvi *.fdb_latexmk *.fls *.log *.out *.ps *.run.xml

# Sync BUILD_NAME into the CI workflow
sync-ci:
	yq -i '.env.BUILD_NAME = "$(BUILD_NAME)"' .github/workflows/build.yml

.PHONY: all clean sync-ci
