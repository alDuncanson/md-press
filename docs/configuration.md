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
| `deploy` | `auto` deploys to GitHub Pages except on pull requests, which build a preview; `true` or `false` forces it | `auto` |
| `artifact-name` | Name of the site artifact uploaded when not deploying | `md-press-site` |
| `pr-comment` | Comment on pull requests with links to the preview artifacts | `true` |
| `pandoc-version` | [pandoc release](https://github.com/jgm/pandoc/releases) to install | `3.12.1` |
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
- uses: alDuncanson/md-press@v0.4.0
  with:
    source: essay.md
    output-pdf: essay.pdf
```

## Multi-file mode

Use the `sources` input with glob patterns to publish multiple documents:

```yaml
- uses: alDuncanson/md-press@v0.4.0
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
- uses: alDuncanson/md-press@v0.4.0
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

These are pandoc variables for its LaTeX template; see pandoc's
[variables for LaTeX](https://pandoc.org/MANUAL.html#variables-for-latex) for
the full list.

## Page titles and share cards

Each HTML page gets a `<title>` and OpenGraph tags, so links shared in Slack,
LinkedIn, or X show a card with the title and preview image. The title comes
from the frontmatter `title`, then the first `#` heading, then the file name.
Set `description` in the frontmatter to add a description to the card.

```markdown
---
description: Software engineer in Grand Rapids, MI
---

# Al Duncanson
```

Setting `title` in the frontmatter also adds a title block to the PDF and HTML,
so documents that already start with a `#` heading usually leave it unset.

## Generating without deploying

To generate files without deploying to GitHub Pages (useful for downloading artifacts or custom deployment):

```yaml
- uses: alDuncanson/md-press@v0.4.0
  with:
    deploy: false
```

The generated files will be in the `_site/` directory, and are uploaded as a
workflow artifact named by `artifact-name`. In single-file and combined modes,
the PDF and preview image (and, for a single file, the HTML page) are also
uploaded as individual unzipped artifacts that open directly in the browser.

## Pull request previews

The [quick start](../README.md#quick-start) workflow already builds previews.
With the default `deploy: auto`, pull requests build the PDF, HTML, and preview
image without publishing, and `md-press` comments on the pull request with
links to them. The comment is updated on each push instead of adding a new one.

A workflow needs three things for previews:

- A `pull_request:` trigger.
- `pull-requests: write` permission, so the action can comment. Without it, or
  on pull requests from forks, the action logs a warning and the artifacts are
  still available from the workflow run.
- An environment name that is empty on pull requests:

  ```yaml
  environment:
    name: ${{ github.event_name != 'pull_request' && 'github-pages' || '' }}
  ```

  The `github-pages` environment only allows deployments from the default
  branch, so a pull request job that references it fails before it starts.

To keep previews from cancelling or waiting behind a Pages deployment, give
pull requests their own concurrency group:

```yaml
concurrency:
  group: ${{ github.event_name == 'pull_request' && format('preview-{0}', github.ref) || 'pages' }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}
```

Artifact links require signing in to GitHub and expire with the repository's
artifact retention period. If a workflow calls `md-press` more than once, give
each call a different `artifact-name` and output filenames, because artifact
names must be unique within a workflow run.

## Troubleshooting

- **`Source file 'document.md' was not found`:** add `document.md` to the
  repository root, or set `source:` to your Markdown file.
- **`Ensure GitHub Pages has been enabled`:** go to **Settings → Pages** and set
  **Source** to **GitHub Actions**.
- **`Branch ... is not allowed to deploy to github-pages`:** the job references
  the `github-pages` environment on a pull request. Use the environment
  expression from [pull request previews](#pull-request-previews).
