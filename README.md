# LaTeX Homework Template

This repository provides a LaTeX template for creating homework assignments.

## Overview

This template is designed to be easily configurable for various assignments. The main file is `assignment.tex`, which you can rename to reflect the specific assignment you are working on. The template is structured to separate content, formatting, and preamble, making it easy to manage your work.

## File Structure

- `assignment.tex`: The main LaTeX file. **You should rename this file.**
- `preamble.tex`: Contains all the `\usepackage` commands and document setup.
- `format.tex`: Defines the visual formatting of the document, including theorem and problem environments.
- `header.tex`: Defines the header of the document, including name, class, and assignment details.
- `problem1.tex`: An example file for writing a problem and its solution. You can create more `problemX.tex` files and include them in your main `.tex` file.
- `.latexmkrc`: Configuration file for `latexmk`, specifying the main document to build.
- `.github/workflows/build.yml`: GitHub Actions workflow for automatically building the PDF.

## How to Use

1.  **Rename `assignment.tex`**:
    Rename `assignment.tex` to a name that is representative of your project (e.g., `homework1.tex`).

2.  **Update `.latexmkrc`**:
    Open the `.latexmkrc` file and change `assignment.tex` to your new filename. For example:
    ```
    $pdf_mode = 2;
    @default_files = ('homework1.tex');
    ```

3.  **Update `.github/workflows/build.yml`**:
    Open the `.github/workflows/build.yml` file and find the `create release` step. Change `assignment.pdf` to your new PDF filename. For example:
    ```yaml
    - name: create release
      uses: softprops/action-gh-release@v2
      if: github.ref_type == 'tag'
      with:
        files: |
          homework1.pdf
    ```

## Building the PDF

To compile the LaTeX project and generate a PDF, you can use `latexmk`. With the `.latexmkrc` file correctly configured, you can simply run:

```bash
latexmk
```

This will generate a PDF with the same name as your main `.tex` file.

## CI/CD

This repository includes a GitHub Actions workflow in `.github/workflows/build.yml` that automatically builds the PDF of your assignment. The workflow is triggered on pushes and pull requests to the `main` branch, and also when a new tag is created.

When a tag is pushed, the workflow will create a new release and upload the compiled PDF as a release artifact.