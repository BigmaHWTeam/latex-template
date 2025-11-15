# LaTeX Homework Template

This repository provides a LaTeX template for creating homework assignments.

## Overview

This template is designed to be easily configurable for various assignments. The main file can be renamed to reflect the specific assignment you are working on. The template is structured to separate content, formatting, and preamble, making it easy to manage your work.

## File Structure

- `assignment.tex`: The main LaTeX file. You can rename this file.
- `preamble.tex`: Contains all the `\usepackage` commands and document setup.
- `format.tex`: Defines the visual formatting of the document, including theorem and problem environments.
- `header.tex`: Defines the header of the document, including name, class, and assignment details.
- `problem1.tex`: An example file for writing a problem and its solution. You can create more `problemX.tex` files and include them in your main `.tex` file.
- `Makefile`: Contains the build instructions for the project.
- `.latexmkrc`: Configuration file for `latexmk`.
- `.github/workflows/build.yml`: GitHub Actions workflow for automatically building the PDF.

## How to Use

1.  **Customize Metadata (Optional)**:
    Open `header.tex` and edit the variables (`\myname`, `\classname`, etc.) to set your name, class, and other details.

2.  **Rename the Main File (Optional)**:
    If you want to rename `assignment.tex` (e.g., to `homework1.tex`), you will need to update the `MAIN_FILE` variable in two places:
    - **Makefile**: Change `MAIN_FILE ?= assignment` to `MAIN_FILE ?= homework1`.
    - **`.github/workflows/build.yml`**: Change `MAIN_FILE: assignment` to `MAIN_FILE: homework1`.

## Building the PDF

To compile the LaTeX project and generate a PDF, you can use the included `Makefile`.

- **To build the default file (`assignment.pdf`)**:
  ```bash
  make
  ```

- **To build a differently named file**:
  You can specify the main file by passing the `MAIN_FILE` variable to the `make` command.
  ```bash
  make all MAIN_FILE=homework1
  ```
  This will generate `homework1.pdf`.

## CI/CD

This repository includes a GitHub Actions workflow in `.github/workflows/build.yml` that automatically builds the PDF of your assignment. The workflow is triggered on pushes and pull requests to all branches, and also when a new tag is created.

When a tag is pushed, the workflow will create a new release and upload the compiled PDF as a release artifact.

> **Important:** For the CI/CD workflow to function correctly, you must enable "Read and Write permissions" for workflows in your GitHub repository settings. You can find this setting under `Settings > Actions > General > Workflow permissions`.