# `md-press`

[![Release Workflow](https://github.com/alDuncanson/md-press/actions/workflows/release.yml/badge.svg)](https://github.com/alDuncanson/md-press/actions/workflows/release.yml)
[![Latest Release](https://img.shields.io/github/v/release/alDuncanson/md-press)](https://github.com/alDuncanson/md-press/releases)
[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-md--press-blue?logo=github)](https://github.com/marketplace/actions/md-press)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Publish Markdown documents for free with `md-press`.

## Quick start

```yaml
name: Publish

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
      url: ${{ steps.md-press.outputs.page_url }}
    steps:
      - uses: actions/checkout@v4
      - uses: alDuncanson/md-press@v0.1.6
        id: md-press
```

> [!NOTE]
> Your repository must have GitHub Pages enabled with **GitHub Actions** as the
> source. Go to Settings → Pages → Source → select "GitHub Actions".

This converts `document.md` into a PDF, an HTML page, and a preview image, then
deploys everything to GitHub Pages.

See [my resume](https://github.com/alDuncanson/resume) for a single-document
publishing example, or [essays](https://github.com/alDuncanson/essays) for a
multi-document example.

## Configuration

The defaults work for a single-document workflow, but `md-press` supports custom
filenames, multi-file publishing, and PDF styling through YAML frontmatter.

See [docs/configuration.md](docs/configuration.md) for the full reference.
