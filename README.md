# Scribe

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Scribe-blue?logo=github)](https://github.com/marketplace/actions/scribe)
[![GitHub release](https://img.shields.io/github/v/release/alDuncanson/scribe)](https://github.com/alDuncanson/scribe/releases)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Scribe is a Markdown document processor that turns your writing into free, hosted web pages, downloadable PDFs, and shareable preview images — all powered by GitHub Actions and GitHub Pages.

Write in Markdown. Push to GitHub. Get a published document.

## Why Scribe

Publishing a document online usually means choosing between clunky website builders, expensive hosting, or complex static site generators. Scribe takes a different approach: you write Markdown, and GitHub handles the rest.

This makes it ideal for:

- **Resumes** — host a professional PDF and web version at a permanent URL
- **Essays and articles** — publish long-form writing without a full blog setup
- **Poems and creative writing** — share your work with a clean, readable format
- **Homework and academic papers** — generate properly formatted PDFs from plain text
- **Documentation** — create standalone reference documents

See the [resume template](https://github.com/alDuncanson/resume) for the project that inspired Scribe.

## Features

- Converts Markdown to PDF using pandoc and tectonic (LaTeX)
- Generates standalone HTML pages
- Creates preview PNG images from the PDF
- Automatically deploys to GitHub Pages — no extra configuration needed
- Supports YAML frontmatter for PDF styling (margins, fonts, etc.)

## Requirements

Your repository must have GitHub Pages enabled with "GitHub Actions" as the source (Settings → Pages → Source → GitHub Actions).

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

That's it. Scribe handles the artifact upload and GitHub Pages deployment automatically.

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
