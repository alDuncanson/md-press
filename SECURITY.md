# Security

md-press is a composite GitHub Action. It runs inside your workflow with the
token and permissions you give it, converts your Markdown with pinned pandoc
and tectonic releases, and deploys to your GitHub Pages site.

## Using it safely

- Pin a release tag such as `alDuncanson/md-press@v0.5.1`, or a full commit
  SHA if you want the reference to be immutable. Release tags are protected
  from being moved or deleted.
- Grant only the permissions the README shows for your deploy mode.

## Reporting a vulnerability

Use [private vulnerability reporting](https://github.com/alDuncanson/md-press/security/advisories/new)
rather than a public issue. Expect an acknowledgement within a week.

## Supported versions

Only the latest release.
