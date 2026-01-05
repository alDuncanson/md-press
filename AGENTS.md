# AGENTS.md

## Overview

md-press is a GitHub Action (composite action) that converts Markdown to PDF, HTML, and preview images, then deploys to GitHub Pages. No build system or package manager—just shell scripts in `action.yml`.

## Testing

- **CI tests**: Run on PRs via `.github/workflows/test.yml`
- **Local testing**: Use [act](https://github.com/nektos/act) or test in a separate repo that references this action

## Architecture

- `action.yml` — The entire action logic (composite action with bash steps)
- Uses: pandoc (md→pdf/html), tectonic (LaTeX engine), poppler-utils (pdf→png)
- Output goes to `_site/` directory, deployed via `actions/deploy-pages`

## Code Style

- YAML for action definition; bash for steps
- Use `${{ inputs.* }}` and `${{ github.* }}` for templating
- Keep steps atomic and well-named
- Quote shell variables; use heredocs for multi-line content
