# Example 2 — PR Network + Security Review

## Scenario

A teammate opened a PR that touches networking and IAM. You want a focused pre-merge review before approving.

## Invocation

```
Run /gcp-architecture-best-practices-reviewer on this PR.

Scope: network + security categories only.
PR: #142 (feature/add-psc-langfuse).
Evidence: the diff plus the existing files it touches.
Severity floor: Medium.
Output: post a Markdown block in chat for me to paste into the PR.
Read-only.
```

## What the skill does

1. Reads the PR diff (`gh pr diff 142`).
2. Reads the modified files at their PR-head versions.
3. Pulls only `checklists/network.md` and `checklists/security.md`.
4. Filters out anything below Medium.
5. Returns a chat-shaped Markdown block (not a separate file).

## Expected output shape

```markdown
## PR #142 Review — Network + Security — 2026-05-11

**Filters:** Network + Security categories; Severity floor Medium.

**Verdict:** 2 High, 3 Medium. Block merge until High items addressed.

---

## FINDING-HIGH-001: Service-to-service ingress allowed from 0.0.0.0/0 on internal LB

Severity: High

Category:
Network

Evidence:
- File/path/resource inspected: terraform/modules/internal-lb/main.tf:45-58
- Relevant configuration/code/document excerpt:
  source_ranges = ["0.0.0.0/0"]
- Why this is evidence: Firewall rule attached to internal LB target tag accepts public ingress.

Problem:
The firewall rule fronting this internal load balancer accepts traffic from the public internet,
defeating the internal-LB purpose.

Risk:
Service intended for internal callers is reachable from anywhere. Any auth weakness becomes
internet-exposed.

Recommendation:
Restrict source_ranges to the consumer subnet CIDR(s). If service is genuinely cross-project,
use Private Service Connect endpoint allowlist instead of broad CIDR.

Validation:
gcloud compute firewall-rules describe <rule> --format='value(sourceRanges)'
Expected: list contains only internal CIDR ranges.

CIS / GCP Best Practice Mapping:
CIS GCP Foundation Benchmark concept: firewall rules restrict ingress sources.

Tradeoff:
External callers (if any) will be blocked. Confirm no public consumers; if external, use a
separate external LB with Cloud Armor — do not weaken this internal one.

Open Questions:
None.

---

## FINDING-HIGH-002: New service account granted roles/owner

Severity: High

Category:
IAM

Evidence:
- File/path/resource inspected: terraform/iam/service-accounts.tf:312
- Relevant configuration/code/document excerpt:
  resource "google_project_iam_member" "psc_sa_owner" {
    role   = "roles/owner"
    member = "serviceAccount:psc-controller@${var.project_id}.iam.gserviceaccount.com"
  }
- Why this is evidence: Direct grant of primitive role.

Problem:
Service account receives roles/owner. Primitive role grants god-tier access far beyond what
PSC controller needs.

Risk:
Compromise of this SA gives full project takeover. Owner can disable audit logging, exfiltrate
all data, alter org policy.

Recommendation:
Replace roles/owner with the minimum set required for PSC:
- roles/compute.networkAdmin (or narrower)
- roles/servicedirectory.editor (if used)
Test against actual PSC TF behavior.

Validation:
gcloud projects get-iam-policy <project> --flatten='bindings[].members'
  --format='value(bindings.role)' --filter='bindings.members:psc-controller'
Expected: list contains only the narrow roles.

CIS / GCP Best Practice Mapping:
CIS GCP Foundation Benchmark concept: IAM least privilege; no primitive roles on workloads.

Tradeoff:
You'll need to iterate on the narrower role set if PSC apply fails. Iterate in plan output,
not by reverting to owner.

Open Questions:
None.

---

[Medium findings follow same template]
```

## What to do

- Block merge on the 2 High findings.
- Drop the chat output into a PR comment.
- Re-run the skill after the PR author addresses the Highs.
