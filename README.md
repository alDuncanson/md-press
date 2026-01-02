# Scribe

A GitHub Action that converts Markdown documents to PDF, HTML, and preview images for publishing. Use it to host resumes, blogs, poems, or any Markdown content.

## Features

- Converts Markdown to PDF using pandoc and tectonic (LaTeX)
- Generates standalone HTML pages
- Creates preview PNG images from the PDF
- Supports YAML frontmatter for PDF styling (margins, fonts, etc.)

## Usage

```yaml
- uses: alDuncanson/scribe@v1
```

### Full Example with GitHub Pages

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
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: alDuncanson/scribe@v1
        with:
          source: resume.md

      - uses: actions/configure-pages@v4

      - uses: actions/upload-pages-artifact@v3
        with:
          path: .

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `source` | Source Markdown file | `resume.md` |
| `output-pdf` | Output PDF filename | `resume.pdf` |
| `output-html` | Output HTML filename | `index.html` |
| `output-preview` | Output preview image filename (without extension) | `preview` |
| `preview-dpi` | Preview image resolution in DPI | `150` |

## Outputs

| Output | Description |
|--------|-------------|
| `pdf` | Path to generated PDF file |
| `html` | Path to generated HTML file |
| `preview` | Path to generated preview PNG file |

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

## License

MIT
