# sevenbelow/claude-tools

Claude Code tools published by [SevenBelow](https://sevenbelow.com) — skills, hooks, slash commands, settings snippets, MCP servers, and utilities.

## What's here

| Type | What it is | Location |
|---|---|---|
| **Skills** | LLM-activated capabilities loaded via SKILL.md | top-level dirs (or `skills/` once N > 1) |
| **Hooks** | Shell scripts triggered by Claude Code events (PreToolUse, PostToolUse, UserPromptSubmit, SessionStart, etc.) | `hooks/` |
| **Slash commands** | Custom `/command` definitions | `commands/` |
| **Settings snippets** | Copy-paste blocks for `~/.claude/settings.json` | `settings/` |
| **MCP servers** | Model Context Protocol servers | `mcp-servers/` |
| **Utilities** | Standalone scripts / helpers | `utils/` |

Subdirectories are added as content lands. Empty directories are not committed.

## Current contents

### Skills

| Skill | Description |
|---|---|
| [`gcp-architecture-best-practices-reviewer`](./gcp-architecture-best-practices-reviewer/) | Evidence-backed GCP architecture review against best practices + CIS GCP Foundation Benchmark concepts. Read-only. |

## Install

### Skills

Place under `~/.claude/skills/` (user-scoped) or `.claude/skills/` (project-scoped):

```bash
git clone https://github.com/sevenbelowllc/claude-tools.git ~/sevenbelow-claude-tools

# User-scoped install (symlink keeps it live)
ln -s ~/sevenbelow-claude-tools/gcp-architecture-best-practices-reviewer ~/.claude/skills/

# OR copy
cp -r ~/sevenbelow-claude-tools/gcp-architecture-best-practices-reviewer ~/.claude/skills/
```

Restart Claude Code or `/skills reload` (if your version supports it).

### Hooks

Reference hooks from `~/.claude/settings.json` `hooks:` block by absolute path. Make scripts executable:

```bash
chmod +x ~/sevenbelow-claude-tools/hooks/*.sh
```

Hook installation guidance lives in each hook's own README.

### Slash commands

Symlink command files into `~/.claude/commands/`:

```bash
ln -s ~/sevenbelow-claude-tools/commands/my-command.md ~/.claude/commands/
```

### MCP servers

Each MCP server has its own README with install + auth setup.

## Invocation (skills)

Once installed, ask Claude Code naturally:

> Review our GCP architecture in this repo.

> Run a CIS GCP alignment check on `terraform/environments/prod/`.

> Audit this Terraform PR for security and cost gaps before merge.

Or invoke explicitly:

> /gcp-architecture-best-practices-reviewer

See each skill's `examples/` directory for worked invocations.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

[MIT](./LICENSE).
