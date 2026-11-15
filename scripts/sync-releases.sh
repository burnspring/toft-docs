#!/usr/bin/env bash
# Copy Toft's release notes (release-notes/<version>.md in the toft repository,
# one per release) into the Release notes guide as releases/vX-Y-Z.md. The toft
# repository writes them; this site only publishes them. Re-run after a deploy.
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
src="${TOFT_CHECKOUT:-$here/../toft}/release-notes"
for f in "$src"/*.md; do
  v=$(basename "$f" .md)
  cp "$f" "$here/src/content/docs/releases/v${v//./-}.md"
done
echo "synced $(ls "$src"/*.md | wc -l) release notes from $src"
