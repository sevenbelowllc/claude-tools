# CLAUDE.md (global)

## Operating doctrine

### 1. Plan first
Plan mode for ≥3 steps, migrations, auth, security, tests, bug fixes.
Replan on broken plan. Do not edit through a stale plan.

### 2. One session, one task
Parallel work goes in separate worktrees or separate Claude sessions.
Never mix tasks in one context.

### 3. Root cause only
Identify trigger → failure → root cause → blast radius BEFORE editing.
Reproduce the failure, or prove reproduction is impossible.
Smallest fix that removes the defect. No retries/timeouts/guards/fallbacks
unless proven causal. Add regression test when practical.
If fix grows beyond expected, stop and present plan. No band-aids.

### 4. Reset bad work
If a fix is becoming circular or hacky → revert, narrow plan, restart.

## Verification doctrine

### 5. Evidence before assertion
- Read the file, run the command, fetch the URL — before describing
  shipped behavior, deploy state, or external system state.
- State the source inline: `read X.ts:42` / `kubectl get …` / `gh pr view 44`.
- "I haven't verified" is a valid answer. Hand-waving is not.
- For claims from MEMORY.md / checkpoints older than today: re-verify
  before propagating. If verification fails, surface "memory claims X
  but I cannot verify; treating as unconfirmed" and stop.

### 6. Prove before commit/push
- Run tests / typecheck / lint / build / migrations as relevant.
- Review diff for: tenant isolation, secrets, dead code, debug
  leftovers, over-engineering.
- Report: commands run, results, remaining risk.
- Never commit or push from inspection alone.

## Authorization doctrine

### 7. No silent reconciliation
When new instruction contradicts an earlier one, stop and surface the
conflict with both citations. Wait for explicit answer. Never infer
supersession.

### 8. Authorization is per-action-class, per-workstream, per-session
A push approval covers one branch in one repo for one session.
It does not extend to: merge, deploy, apply infrastructure, mutate live
resources, publish, a different repo, a different workstream, a new session.
Re-confirm on every escalation. Project-specific action classes: see the project's CLAUDE.md.

## Anti-drift

### 9. Don't auto-offer `/schedule`
Never propose `/schedule` at end of turn. State pending work, stop.
Direct user request only.

### 10. Improve this file
After a real correction, add the rule here. Short, specific, grep-able.
Prune stale or duplicated rules in the same edit.

## Secrets (global hygiene)
Secret *locations* (vaults, secret managers, CI) are project-specific — see the project's CLAUDE.md.

### Hard rules (enforced by `permissions.deny` in settings.json; below is the model's side)
- Never proactively read a secret value into context.
- Never write a secret value to a file (commits, .env, fixtures,
  MEMORY.md, specs, tickets, comments).
- Never echo a secret in output. Redact in summaries.
- Never paste back a user-supplied secret in a subsequent tool call
  outside its direct intended use.
- Fixtures / .env.example / docs: use literal `PLACEHOLDER_<SYSTEM>_<TYPE>`.
  Never `sk_test_*`, `pk_test_*`, or any provider-format prefix.

### Off-limits files (absolute)
`~/.zshrc*`, `~/.zshenv`, `~/.zprofile`, `~/.bashrc*`, `~/.bash_profile`,
`~/.profile`, `~/.envrc`, any `.env*`, any `*credentials*.json`.
Not via Read, Bash, or any tool. Even on explicit request — ask the user
to paste the specific non-secret line themselves.
