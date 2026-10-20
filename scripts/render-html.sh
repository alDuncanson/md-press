#!/usr/bin/env bash
# Render a Markdown file to a standalone HTML page with a page title and
# OpenGraph/Twitter share-card tags.
#
# Usage: render-html.sh SOURCE DEST PAGE_URL IMAGE_URL
#
# The title comes from the frontmatter `title`, then the first level-one
# heading, then the file name. The description comes from the frontmatter
# `description`, if set.
set -euo pipefail

SOURCE=$1
DEST=$2
PAGE_URL=$3
IMAGE_URL=$4

ACTION_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

# Print a metadata field from the source's frontmatter as plain text
metadata() {
  printf '$%s$' "$1" > "$WORK_DIR/field.txt"
  pandoc "$SOURCE" -t plain --wrap=none --template="$WORK_DIR/field.txt"
}

escape_attr() {
  sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' <<< "$1"
}

TITLE=$(metadata title)
PAGETITLE_ARGS=()
if [ -z "$TITLE" ]; then
  HEADING=$(grep -m1 '^# ' "$SOURCE" || true)
  if [ -n "$HEADING" ]; then
    TITLE=$(printf '%s\n' "${HEADING#\# }" | pandoc -f markdown -t plain --wrap=none)
  else
    TITLE=$(basename "${SOURCE%.md}")
  fi
  # Sets <title> without adding a title block to the page
  PAGETITLE_ARGS=(--metadata "pagetitle=${TITLE}")
fi
DESCRIPTION=$(metadata description)

{
  echo '<meta property="og:type" content="website">'
  echo "<meta property=\"og:title\" content=\"$(escape_attr "$TITLE")\">"
  if [ -n "$DESCRIPTION" ]; then
    echo "<meta property=\"og:description\" content=\"$(escape_attr "$DESCRIPTION")\">"
  fi
  echo "<meta property=\"og:url\" content=\"$(escape_attr "$PAGE_URL")\">"
  echo "<meta property=\"og:image\" content=\"$(escape_attr "$IMAGE_URL")\">"
  echo '<meta name="twitter:card" content="summary_large_image">'
  echo "<meta name=\"twitter:image\" content=\"$(escape_attr "$IMAGE_URL")\">"
} > "$WORK_DIR/header.html"

mkdir -p "$(dirname "$DEST")"
echo "Converting $SOURCE -> $DEST"
pandoc -s "$SOURCE" -o "$DEST" \
  --include-in-header="$WORK_DIR/header.html" \
  --lua-filter="$ACTION_ROOT/filters/mdlinks-to-html.lua" \
  "${PAGETITLE_ARGS[@]}"
