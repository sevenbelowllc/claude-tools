#!/usr/bin/env bash
# Capture the current live Claude config into this repo, then commit.
#
# Machine/account-specific values are pulled from the shell and replaced with
# placeholder tokens before commit, so no literal lands in this (public) repo.
# restore.sh rehydrates them from the same env vars. To protect another value,
# add a row to the SUBST_* table below -- both scripts read the same model.
#
# Usage:  ./capture.sh ["optional commit message"]
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export HOME

# Machine/account-specific values live in local.env (gitignored), so nothing
# org-specific is committed. Copy local.env.example -> local.env and edit.
[ -f "$REPO_DIR/local.env" ] && . "$REPO_DIR/local.env"
: "${CLAUDE_SNAPSHOT_PROJ:?not set — copy local.env.example to local.env and edit}"
export PROJ="$CLAUDE_SNAPSHOT_PROJ"

# token  <->  env var holding the live value. Same model for every value.
SUBST_TOKEN=( "__HOME__"  "__GCP_PROJECT_ID__"   )
SUBST_VAR=(   "HOME"      "GOOGLE_CLOUD_PROJECT"  )

# Refuse to capture if a required value is missing, so a literal can't leak.
for i in "${!SUBST_VAR[@]}"; do
  var="${SUBST_VAR[$i]}"
  if [ -z "${!var:-}" ]; then
    echo "ERROR: \$$var is not set; needed to sanitize ${SUBST_TOKEN[$i]} before" >&2
    echo "       commit. Set it and retry." >&2
    exit 1
  fi
done

cd "$REPO_DIR"
copied=0
dests=()
while read -r live repo || [ -n "${live:-}" ]; do
  case "$live" in ''|\#*) continue;; esac
  src="$(eval echo "$live")"
  dst="$REPO_DIR/$repo"
  if [ ! -f "$src" ]; then
    echo "WARN: missing live file, skipping: $src" >&2
    continue
  fi
  mkdir -p "$(dirname "$dst")"
  cp -p "$src" "$dst"
  dests+=("$dst")
  copied=$((copied + 1))
done < "$REPO_DIR/manifest.txt"
echo "Captured $copied files."

# Sanitize: live value -> placeholder token across every captured file.
for f in "${dests[@]}"; do
  for i in "${!SUBST_TOKEN[@]}"; do
    var="${SUBST_VAR[$i]}"; val="${!var}"; tok="${SUBST_TOKEN[$i]}"
    LC_ALL=C sed -i '' "s|${val}|${tok}|g" "$f"
  done
done
echo "Sanitized ${#SUBST_TOKEN[@]} value(s) -> placeholder tokens."

git add -A
if git diff --cached --quiet; then
  echo "No changes since last snapshot."
else
  msg="${1:-snapshot $(date '+%Y-%m-%d %H:%M:%S')}"
  git commit -q -m "$msg"
  echo "Committed: $msg"
fi
