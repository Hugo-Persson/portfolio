# Typst Resume

This directory contains your resume converted from LaTeX to Typst.

## Files

- `resume.typ` - Main resume file
- `resume-template.typ` - Template functions and styling

## Installation

To compile the Typst resume, you need to install Typst first:

### macOS (using Homebrew)
```bash
brew install typst
```

### macOS (using Cargo)
```bash
cargo install --git https://github.com/typst/typst --locked typst-cli
```

### Other platforms
Visit https://github.com/typst/typst for installation instructions.

## Compilation

To compile the resume to PDF:

```bash
typst compile resume.typ
```

This will generate `resume.pdf` in the same directory.

To watch for changes and auto-recompile:

```bash
typst watch resume.typ
```

## Editing

Edit `resume.typ` to update your resume content. The template functions in `resume-template.typ` provide the styling and layout.

## Differences from LaTeX

- Simpler syntax - no need for `\begin{document}` or complex class files
- Faster compilation
- Better error messages
- Modern tooling with live preview support

## Original LaTeX Files

The original LaTeX files are still in this directory:
- `mmayer.tex` - Original LaTeX resume
- `altacv.cls` - LaTeX class file
- `page1sidebar.tex`, `page2sidebar.tex` - Sidebar content
