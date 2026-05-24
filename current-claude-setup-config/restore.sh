#!/usr/bin/env bash
# Restore Claude config from this snapshot back to its live locations.
#
# Default is a DRY RUN (shows diffs only). Pass --apply to write; every
# overwritten file is first backed up under .restore-backup/<timestamp>/.
# Placeholder tokens are rehydrated from the shell (see the SUBST_* table,
# which must match capture.sh).
#
# Usage:  ./restore.sh            # preview
#         ./restore.sh --apply    # write changes
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export HOME

# Machine/account-specific values live in local.env (gitignored), so nothing
# org-specific is committed. Copy local.env.example -> local.env and edit.
[ -f "$REPO_DIR/local.env" ] && . "$REPO_DIR/local.env"
: "${CLAUDE_SNAPSHOT_PROJ:?not set — copy local.env.example to local.env and edit}"
export PROJ="$CLAUDE_SNAPSHOT_PROJ"

# token  <->  env var holding the live value. Must match capture.sh.
SUBST_TOKEN=( "__HOME__"  "__GCP_PROJECT_ID__"   )
SUBST_VAR=(   "HOME"      "GOOGLE_CLOUD_PROJECT"  )

APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1
BACKUP_DIR="$REPO_DIR/.restore-backup/$(date '+%Y%m%d-%H%M%S')"
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
TOKEN_RE="$(IFS='|'; echo "${SUBST_TOKEN[*]}")"
changes=0

while read -r live repo || [ -n "${live:-}" ]; do
  case "$live" in ''|\#*) continue;; esac
  dst="$(eval echo "$live")"
  repo_file="$REPO_DIR/$repo"
  [ -f "$repo_file" ] || { echo "WARN: snapshot missing $repo" >&2; continue; }

  # Rehydrate placeholder tokens from the shell into a temp copy.
  src="$repo_file"
  if grep -qE "$TOKEN_RE" "$repo_file" 2>/dev/null; then
    src="$WORK/${repo//\//_}"
    cp "$repo_file" "$src"
    skip=0
    for i in "${!SUBST_TOKEN[@]}"; do
      tok="${SUBST_TOKEN[$i]}"; var="${SUBST_VAR[$i]}"; val="${!var:-}"
      grep -q "$tok" "$src" 2>/dev/null || continue
      if [ -z "$val" ]; then
        echo "WARN: $repo needs \$$var to rehydrate $tok; skipping file." >&2
        skip=1; break
      fi
      LC_ALL=C sed -i '' "s|${tok}|${val}|g" "$src"
    done
    [ "$skip" = 1 ] && continue
  fi

  if [ -f "$dst" ] && diff -q "$src" "$dst" >/dev/null 2>&1; then
    continue  # already identical
  fi
  changes=$((changes + 1))
  if [ "$APPLY" = 1 ]; then
    if [ -f "$dst" ]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$repo")"
      cp -p "$dst" "$BACKUP_DIR/$repo"
    fi
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    chmod "$(stat -f '%Lp' "$repo_file")" "$dst"
    echo "restored: $dst"
  else
    echo "WOULD restore: $dst"
    diff -u "$dst" "$src" 2>/dev/null | sed 's/^/    /' || true
  fi
done < "$REPO_DIR/manifest.txt"

echo
if [ "$changes" -eq 0 ]; then
  echo "Live config already matches the snapshot. Nothing to do."
elif [ "$APPLY" = 1 ]; then
  echo "Done ($changes file(s)). Overwritten originals backed up under:"
  echo "  $BACKUP_DIR"
  echo "Restart Claude Code (or reload settings) for changes to take effect."
else
  echo "Dry run: $changes file(s) differ. Re-run to write:  ./restore.sh --apply"
fi
