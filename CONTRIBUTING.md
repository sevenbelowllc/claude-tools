# Contributing

This repo hosts multiple kinds of Claude Code extensions: skills, hooks, slash commands, settings snippets, MCP servers, utilities. Each kind has its own conventions.

## Layout

```
sevenbelowllc/claude-tools/
├── <skill-name>/         # skill at the top level if it has its own README
├── hooks/
│   └── <hook-name>/      # per-hook directory with README + script
├── commands/
│   └── <command>.md      # one file per slash command
├── settings/
│   └── <snippet>.json    # copy-paste settings.json fragments
├── mcp-servers/
│   └── <server-name>/    # per-server directory with README + impl
└── utils/
    └── <utility>/        # standalone scripts / helpers
```

Skills currently live at the top level because there's only one. Once a second skill lands, all skills move under `skills/<name>/`.

## Adding a skill

1. Create `<skill-name>/` (top-level, until a second skill exists; then under `skills/`).
2. Add `SKILL.md` with required frontmatter.
3. Keep `SKILL.md` under ~400 lines. Move detail into `checklists/`, `references/`, `templates/`, `examples/`.
4. Include at least 2 worked examples under `examples/`.
5. Add row to repo `README.md` skill table.
6. Open PR.

### SKILL.md shape

```yaml
---
name: my-skill
description: One-line that triggers LLM activation. Match user phrasings.
when_to_use: Specific scenarios that should fire the skill.
allowed-tools: [Bash, Read, Grep, Glob, WebFetch]   # optional
license: MIT
---

# my-skill

## Role / Goal / Inputs / Outputs / When-to-use / When-not-to-use
## Workflow
## Safety
## Examples (pointers)
## References (pointers)
```

## Adding a hook

1. Create `hooks/<hook-name>/`.
2. Add `README.md` documenting the trigger event, what it blocks, expected stdin shape, exit codes.
3. Add the script (`*.sh`, `*.py`, etc.). Make executable.
4. Add a `settings-snippet.json` showing the `~/.claude/settings.json` block that wires the hook.
5. Open PR.

## Adding a slash command

1. Create `commands/<command>.md`.
2. Include frontmatter if your version supports it; otherwise plain markdown body is the prompt.
3. Document in repo `README.md` if it deserves callout.

## Adding an MCP server

1. Create `mcp-servers/<server-name>/`.
2. Include `README.md` (install, auth, env vars, tool list).
3. Include `package.json` / `pyproject.toml` / equivalent.
4. Include a sample `mcp.json` registration block.

## Rules (apply to everything)

- **Read-only by default.** Mutating tools require justification + explicit user opt-in at runtime.
- **No vendor lock.** Tools work for any consumer, not one organization. No internal URLs, ticket IDs, or memory references.
- **Primary sources only.** Cite official docs, not internal summaries.
- **Examples must run.** Each example produces the documented output shape against a representative input.
- **Progressive disclosure for skills.** Heavy content lives in referenced files; `SKILL.md` is the compact entry point.
- **Hooks must fail loud.** A hook that silently passes when it should block is worse than no hook.
- **No secrets in source.** Test fixtures use `PLACEHOLDER_*` literals. No realistic-looking keys or tokens.

## License

By contributing, you agree your contribution is licensed under the repo's [MIT License](./LICENSE).
