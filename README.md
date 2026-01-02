# Scribe

A GitHub Action that converts Markdown documents to PDF, HTML, and preview images, then automatically deploys them to GitHub Pages.

## Features

- Converts Markdown to PDF using pandoc and tectonic (LaTeX)
- Generates standalone HTML pages
- Creates preview PNG images from the PDF
- **Automatically deploys to GitHub Pages** — no extra configuration needed
- Supports YAML frontmatter for PDF styling (margins, fonts, etc.)

## Usage

```yaml
name: Publish Document

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  publish:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.scribe.outputs.page_url }}
    steps:
      - uses: actions/checkout@v4

      - uses: alDuncanson/scribe@v1
        id: scribe
        with:
          source: resume.md
```

That's it! Scribe handles the artifact upload and GitHub Pages deployment automatically.

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `source` | Source Markdown file | `resume.md` |
| `output-pdf` | Output PDF filename | `resume.pdf` |
| `output-html` | Output HTML filename | `index.html` |
| `output-preview` | Output preview image filename (without extension) | `preview` |
| `preview-dpi` | Preview image resolution in DPI | `150` |
| `deploy` | Whether to deploy to GitHub Pages | `true` |

## Outputs

| Output | Description |
|--------|-------------|
| `pdf` | Path to generated PDF file |
| `html` | Path to generated HTML file |
| `preview` | Path to generated preview PNG file |
| `page_url` | URL of the deployed GitHub Pages site |

## Build Only (No Deploy)

If you want to generate files without deploying:

```yaml
- uses: alDuncanson/scribe@v1
  with:
    source: document.md
    deploy: 'false'
```

## Markdown Frontmatter

Control PDF styling with YAML frontmatter:

```markdown
---
geometry: margin=0.5in
header-includes: |
  \pagenumbering{gobble}
---

# Your Document

Content here...
```

## Requirements

Your repository must have GitHub Pages enabled with "GitHub Actions" as the source (Settings → Pages → Source → GitHub Actions).
