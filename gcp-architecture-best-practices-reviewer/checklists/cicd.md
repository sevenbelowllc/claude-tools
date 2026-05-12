# CI/CD + Supply Chain Checklist

## Source control

- [ ] Branch protection on `main` / `prod` / `release` branches.
- [ ] Required reviews (≥ 1, ideally ≥ 2 for production-bound branches).
- [ ] Required status checks: tsc/lint, tests, secret-scan, IaC plan.
- [ ] Force-push disabled on protected branches.
- [ ] Signed commits required for production-bound branches.

## CI authentication

- [ ] Workload Identity Federation from GitHub Actions / Buildkite / GitLab to GCP.
- [ ] No long-lived service account JSON keys in CI.
- [ ] OIDC trust scoped to specific repo + branch + workflow.

## Pre-commit / pre-push hooks

- [ ] Secret scanning (gitleaks / trufflehog) on commit AND CI.
- [ ] TypeScript / Python / language-specific lint + typecheck.
- [ ] Test suite or fast subset.
- [ ] License header check (if required).

## Build provenance

- [ ] Container images built in CI, not on developer machines.
- [ ] Image digests captured in deploy manifests; mutable tags not used to deploy.
- [ ] SLSA-aligned build provenance attached (level 2+ target).
- [ ] Images signed; signatures verified at deploy time via Binary Authorization.

## Artifact Registry

- [ ] All images come from Artifact Registry — no Docker Hub, no `quay.io`, no `gcr.io/google-containers` in production.
- [ ] Image retention policy in place — no unbounded image history.
- [ ] Vulnerability scanning (Artifact Analysis) enabled.
- [ ] Severity gate on deploy: HIGH / CRITICAL CVEs block.

## Terraform pipeline

- [ ] Plan-only on PR; apply gated on merge to protected branch + human approval.
- [ ] No apply from feature branches.
- [ ] Apply step uses Workload Identity, not exported keys.
- [ ] Plan output posted to PR for review.
- [ ] Atlantis (or equivalent) declared, gated, not bypassable.
- [ ] State files: backend in GCS with object versioning + state-lock.
- [ ] State backend has restricted IAM.

## Deploy strategy

- [ ] Strategy declared per workload (rolling / canary / blue-green / feature-flag).
- [ ] Rollback procedure documented + tested.
- [ ] Pre-deploy smoke + post-deploy validation steps.

## Pipeline secrets

- [ ] Minimum scope per job.
- [ ] Fetched at run time, not baked.
- [ ] Never `echo`'d, never written to logs.
- [ ] Rotation cadence defined.

## Runner posture

- [ ] Ephemeral runners; no persistent state.
- [ ] Runners isolated from production data plane (separate project / network).
- [ ] Runner image pinned, scanned, kept current.

## Audit

- [ ] Every deploy traceable to: commit SHA → reviewer → pipeline run ID → image digest → cluster manifest.
- [ ] Deploy logs retained for compliance window.

## Evidence sources

- `.github/workflows/*.yml` / `.buildkite/pipeline.yml`
- Branch protection settings (`gh api /repos/<owner>/<repo>/branches/main/protection`)
- Workload Identity Federation pool + provider config
- Terraform CI module / `iam.tf` for CI bindings
- Atlantis config if used
- Artifact Registry retention policy
