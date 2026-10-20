# `md-press`

[![Release Workflow](https://github.com/alDuncanson/md-press/actions/workflows/release.yml/badge.svg)](https://github.com/alDuncanson/md-press/actions/workflows/release.yml)
[![Latest Release](https://img.shields.io/github/v/release/alDuncanson/md-press)](https://github.com/alDuncanson/md-press/releases)
[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-md--press-blue?logo=github)](https://github.com/marketplace/actions/md-press)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Publish Markdown documents for free with `md-press`.

## Quick start

1. In your repository, go to **Settings → Pages** and set **Source** to
   **GitHub Actions**.
2. Add the Markdown you want to publish as `document.md` in the repository
   root, or change `source:` in the workflow below to an existing file.
3. Save this workflow as `.github/workflows/publish.yml` and push it to `main`:

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

jobs:
  publish:
    runs-on: ubuntu-latest
    environment:
      name: ${{ github.event_name != 'pull_request' && 'github-pages' || '' }}
      url: ${{ steps.md-press.outputs.page_url }}
    steps:
      - uses: actions/checkout@v7
      - uses: alDuncanson/md-press@v0.3.0
        id: md-press
        with:
          source: document.md
```

Each push to `main` converts your Markdown into a PDF, an HTML page, and a
preview image, and publishes them at `https://<owner>.github.io/<repo>/`.
Pull requests build the same files without publishing, and `md-press` comments
on the pull request with links to them. See
[pull request previews](docs/configuration.md#pull-request-previews) for
details.

See [my resume](https://github.com/alDuncanson/resume) for a single-document
publishing example, or [essays](https://github.com/alDuncanson/essays) for a
multi-document example.

## Configuration

The defaults work for a single-document workflow, but `md-press` supports custom
filenames, multi-file publishing, and PDF styling through YAML frontmatter.

See [docs/configuration.md](docs/configuration.md) for the full reference.
