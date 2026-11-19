#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${1:-exlpxxw7tpiidmjtq-0uux44}"

fail() {
  printf 'PAGES PREFLIGHT BLOCKED: %s\n' "$1" >&2
  exit 1
}

[[ -d "$APP_DIR" ]] || fail "App folder not found: $APP_DIR"
for file in index.html manifest.webmanifest sw.js icon.svg icon-192.png icon-512.png data/index.json; do
  [[ -f "$APP_DIR/$file" ]] || fail "Required app file is missing: $APP_DIR/$file"
done

# Project Pages are mounted below /<repository>/; keep app paths relative to the app directory.
grep -Fq '"start_url":"./' "$APP_DIR/manifest.webmanifest" || fail 'manifest start_url must remain relative (./...) for the project-site subpath'
grep -Fq '"scope":"./"' "$APP_DIR/manifest.webmanifest" || fail 'manifest scope must remain relative (./) for the project-site subpath'
if grep -Eq "(href|src)=[\"']/" "$APP_DIR/index.html"; then
  fail 'Found a root-absolute HTML asset URL; use relative URLs so the repository and app subpaths are preserved'
fi

printf 'PAGES PREFLIGHT PASSED: required app files and relative project-site paths verified. Public app assets are included in the Pages build.\n'
