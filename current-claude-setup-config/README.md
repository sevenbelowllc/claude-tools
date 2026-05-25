# current-claude-setup-config

A small tool to **snapshot and restore Claude Code configuration** so you can reset
to a known-good state. Config only — no secrets, no sessions, no memory.

The generic tooling and the global `CLAUDE.md` are committed here. The rest of the
captured config (settings, hooks, project files), plus machine-specific values, stay
**local and gitignored** — on a fresh clone you supply your own. `restore.sh` places
whatever is present and warns about anything missing.

## Setup

```bash
cp local.env.example local.env      # then edit local.env with your project path
```

`local.env` (gitignored) sets `CLAUDE_SNAPSHOT_PROJ` — the absolute path to the
project whose `.claude` config you snapshot. `GOOGLE_CLOUD_PROJECT` is read from
your shell (or pin it in `local.env`).

## Usage

```bash
./capture.sh                 # copy live config -> ./global, ./project + commit tooling changes
./capture.sh "before X"      # ...with a custom commit message

./restore.sh                 # DRY RUN — show what would change
./restore.sh --apply         # write snapshot back to live locations
```

`restore.sh --apply` backs up every file it overwrites under
`.restore-backup/<timestamp>/` before writing. Restart Claude Code afterward so it
re-reads settings.

## What it snapshots (see `manifest.txt`)

- **Global** (`~/.claude`): `CLAUDE.md`, `settings.json`, `statusline-context.sh`,
  `plugins/known_marketplaces.json`
- **Project** (`$CLAUDE_SNAPSHOT_PROJ`): `CLAUDE.md`, `.mcp.json`,
  `.claude/settings.json`, `.claude/settings.local.json`, `.claude/hooks/*.py`

Edit `manifest.txt` (`<live-path>  <repo-path>`, `$HOME`/`$PROJ` expanded) to add
or remove files.

## Sanitization model

Machine/account-specific values are pulled from the shell at capture time and
stored as placeholder tokens, then rehydrated from the same env vars on restore —
so even the locally-captured files carry no literals. The table lives in both
scripts:

| Token | Sourced from |
|---|---|
| `__HOME__` | `$HOME` |
| `__GCP_PROJECT_ID__` | `$GOOGLE_CLOUD_PROJECT` |

Add a value by appending to `SUBST_TOKEN` / `SUBST_VAR` in both `capture.sh` and
`restore.sh`. `capture.sh` refuses to run if a required env var is unset.

Values already written as `${VAR}` in source config (e.g. API tokens in
`.mcp.json`) are left untouched — Claude Code expands them at runtime.

## Not snapshotted

- `~/.claude.json` and `backups/` — hold MCP OAuth tokens (secrets).
- Transient state: `sessions/`, `history.jsonl`, caches, `file-history/`,
  per-project memory, and cloned plugin marketplaces (re-fetched from
  `known_marketplaces.json`).

## Notes

- Hooks may invoke an interpreter or tools outside this snapshot (e.g. a project
  virtualenv). Recreate those separately; they aren't captured here.
- macOS-specific: scripts use BSD `sed -i ''` and `stat -f`. Adjust for GNU
  coreutils on Linux.
