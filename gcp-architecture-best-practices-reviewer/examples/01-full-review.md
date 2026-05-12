# Example 1 — Full Architecture Review

## Scenario

You have a Terraform monorepo with multiple GCP environments. You want a full architectural review of the `nonprod` environment before promoting any of its patterns to `prod`.

## Invocation

```
Run /gcp-architecture-best-practices-reviewer on our nonprod environment.

Scope: full review.
Repo: this directory.
Primary evidence:
  - terraform/environments/nonprod/
  - docs/architecture/
Environment: nonprod.
CIS benchmark: concepts only, version unverified.
Output: ./reviews/$(date +%F)-nonprod-architecture-review.md
Show all severities.
Read-only run — no remediations on disk.
```

## What the skill does

1. Confirms scope, severity floor, CIS version with you.
2. Walks `terraform/environments/nonprod/` and `docs/architecture/`.
3. Builds an evidence map mapping each review area to actual files.
4. Pulls each checklist under `checklists/` and runs a pass.
5. Drafts findings tagged Confirmed / Inferred / Assumed.
6. Assigns severity per `references/severity-model.md`.
7. Writes report to `./reviews/YYYY-MM-DD-nonprod-architecture-review.md`.

## Expected output shape

```markdown
# GCP Architecture Review — nonprod — 2026-05-11

## 1. Scope and Inputs
- Scope statement: Full architecture review of nonprod
- Repos / paths inspected: terraform/environments/nonprod/, docs/architecture/
- Environments in scope: nonprod
- CIS benchmark version: concepts only, version unverified
- Filters applied: none
- Reviewer: gcp-architecture-best-practices-reviewer
- Run date: 2026-05-11

## 2. Executive Summary
- Total findings by severity: Critical 0, High 4, Medium 11, Low 6, Informational 3
- Top 5 risks:
  1. ...
...

## 3. Evidence Map
| Review area | Primary files / resources | Confirmed? |
|---|---|---|
| Architecture | terraform/environments/nonprod/main.tf | Y |
| Network | terraform/environments/nonprod/network/ | Y |
...

## 4. Findings

### 4.2 High
## FINDING-HIGH-001: Cloud SQL allows public IP authorized network 0.0.0.0/0

Severity: High

Category:
Cloud SQL

Evidence:
- File/path/resource inspected: terraform/environments/nonprod/database/main.tf:147-162
- Relevant configuration/code/document excerpt:
  ip_configuration {
    ipv4_enabled = true
    authorized_networks {
      value = "0.0.0.0/0"
    }
  }
- Why this is evidence: TF declares an authorized network covering the public internet.

Problem:
The Cloud SQL instance allows ingress from any public IP via the authorized_networks block.

Risk:
Any internet-exposed scanner reaching this Cloud SQL instance can attempt authentication.
Combined with weak password / leaked credential, leads to data exposure.

Recommendation:
Remove the `0.0.0.0/0` authorized network. Force private-IP-only access via Cloud SQL Auth
Proxy sidecar (`--private-ip --auto-iam-authn`).

Validation:
gcloud sql instances describe <instance> --format='value(settings.ipConfiguration.authorizedNetworks)'
Expected: empty.

CIS / GCP Best Practice Mapping:
CIS GCP Foundation Benchmark concept: Cloud SQL secure configuration — restrict public ingress.

Tradeoff:
Operators currently reaching the DB from laptops over public IP will need IAP TCP forwarding
or VPN. Document operator-access runbook.

Open Questions:
None.

...
```

## What to do with the report

- Walk findings with the owning team.
- File tickets for any High or Critical.
- For each Medium, decide accept / fix / defer with a written reason.
- Treat the report as a point-in-time artifact — re-run before promoting patterns to prod.
