# Configuration

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `source` | Source Markdown file (single-file mode) | `document.md` |
| `sources` | Space or newline separated list of Markdown files or glob patterns (multi-file mode) | — |
| `output-pdf` | Output PDF filename | `document.pdf` |
| `output-html` | Output HTML filename | `index.html` |
| `output-preview` | Output preview image filename (without extension) | PDF name |
| `preview-dpi` | Preview image resolution in DPI | `150` |
| `mode` | Multi-file mode: `combined` (single PDF) or `collection` (separate PDFs) | `combined` |
| `index-title` | Title for auto-generated index page (multi-file mode) | `Index` |
| `deploy` | Whether to deploy to GitHub Pages | `true` |
| `artifact-name` | Name of the site artifact uploaded when `deploy` is false | `md-press-site` |
| `pr-comment` | Comment on pull requests with links to the preview artifacts | `true` |
| `github-token` | Token used to read the GitHub Pages URL and comment on pull requests | `github.token` |

## Outputs

| Output | Description |
|--------|-------------|
| `pdf` | Path to generated PDF file |
| `html` | Path to generated HTML file |
| `preview` | Path to generated preview PNG file |
| `page_url` | URL of the deployed GitHub Pages site |

## Single-file mode

By default, `md-press` converts a single Markdown file. Override the source and output names as needed:

```yaml
- uses: alDuncanson/md-press@v0.2.0
  with:
    source: essay.md
    output-pdf: essay.pdf
```

## Multi-file mode

Use the `sources` input with glob patterns to publish multiple documents:

```yaml
- uses: alDuncanson/md-press@v0.2.0
  with:
    sources: |
      docs/**/*.md
      articles/*.md
```

In multi-file mode:

- All matched files are converted to HTML, preserving directory structure
- An index page with links to each document is auto-generated
- Relative links between Markdown files (e.g., `[link](other.md)`) are rewritten to `.html`

### Combined vs collection mode

The `mode` input controls PDF generation:

- **`combined`** (default): All documents are merged into a single PDF
- **`collection`**: Each document gets its own PDF, with download links on the index page

```yaml
- uses: alDuncanson/md-press@v0.2.0
  with:
    sources: chapters/*.md
    mode: collection
```

## PDF styling with frontmatter

Control PDF layout using YAML frontmatter in your Markdown files:

```markdown
---
geometry: margin=0.5in
fontsize: 11pt
header-includes: |
  \pagenumbering{gobble}
---

# Your Document

Content here...
```

Common options:

| Variable | Example | Description |
|----------|---------|-------------|
| `geometry` | `margin=0.5in` | Page margins |
| `fontsize` | `10pt`, `11pt`, `12pt` | Base font size |
| `documentclass` | `article`, `report` | LaTeX document class |
| `header-includes` | `\pagenumbering{gobble}` | Raw LaTeX in the preamble |

These are passed directly to the PDF engine, so any valid LaTeX variable works.

## Generating without deploying

To generate files without deploying to GitHub Pages (useful for downloading artifacts or custom deployment):

```yaml
- uses: alDuncanson/md-press@v0.2.0
  with:
    deploy: false
```

The generated files will be in the `_site/` directory, and are uploaded as a
workflow artifact named by `artifact-name`. In single-file and combined modes,
the PDF and preview image (and, for a single file, the HTML page) are also
uploaded as individual unzipped artifacts that open directly in the browser.

## Pull request previews

Build on pull requests without deploying, and `md-press` comments on the pull
request with links to the PDF, HTML, and preview image. The comment is updated
on each push instead of adding a new one.

```yaml
name: Publish

on:
  push:
    branches: [main]
  pull_request:

permissions:
  contents: read
  pages: write
  id-token: write
  pull-requests: write

concurrency:
  group: ${{ github.event_name == 'pull_request' && format('preview-{0}', github.ref) || 'pages' }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}

jobs:
  publish:
    runs-on: ubuntu-latest
    environment:
      name: ${{ github.event_name != 'pull_request' && 'github-pages' || '' }}
      url: ${{ steps.md-press.outputs.page_url }}
    steps:
      - uses: actions/checkout@v7
      - uses: alDuncanson/md-press@v0.2.0
        id: md-press
        with:
          deploy: ${{ github.event_name != 'pull_request' }}
```

- Pull requests skip the `github-pages` environment, whose deployment branch
  policy only allows the default branch.
- Pull requests use their own concurrency group, so a preview never cancels or
  waits behind a Pages deployment.
- `pull-requests: write` lets the action comment. Without it, or on pull
  requests from forks, the action logs a warning and the artifacts are still
  available from the workflow run.
- Artifact links require signing in to GitHub and expire with the repository's
  artifact retention period.
- If a workflow calls `md-press` more than once, give each call a different
  `artifact-name` and output filenames, because artifact names must be unique
  within a workflow run.
