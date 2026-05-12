# Severity Model

Five tiers. Calibration matters — wrong severity dilutes the signal of the entire report.

## Critical

Use ONLY when the issue could directly cause:

- Cross-tenant data exposure
- Public exposure of sensitive systems or data
- Production credential compromise
- Loss of audit integrity
- Uncontrolled production deployment path
- Internet-exposed administrative plane
- Material compliance failure

Test: "If this is true, do we have a P0 incident *right now*?" If yes → Critical.

## High

Substantial risk; not immediately proven active exposure.

Examples:

- Broad IAM roles on production service accounts
- Missing private networking for sensitive services
- Weak CI/CD deployment controls
- Missing centralized audit logs
- Missing GKE Workload Identity controls
- Missing backup/restore proof for critical data stores
- Public hairpin for service-to-service traffic
- Service account JSON keys exported and in use

Test: "If an attacker found this and chose to exploit it, could they reach Critical-level damage?" If yes → High.

## Medium

Meaningful but bounded issues.

Examples:

- Incomplete lifecycle policies
- Missing cost controls
- Missing alerting
- Inconsistent naming/tagging
- Missing non-production isolation controls
- Weak operational documentation
- Logging coverage gaps in non-sensitive paths
- Resource limits unset on non-critical workloads

Test: "Does this hurt us today, but bounded to a known scope?" If yes → Medium.

## Low

Cleanup or hardening issues with no immediate risk.

Examples:

- Image tag pinning where digests would be safer
- Cosmetic naming drift
- Untagged but functional resources
- Documentation freshness
- Soft deprecations

## Informational

Observations, context, architectural notes. No risk implied.

Examples:

- "VPC CIDR allocation suggests headroom for N future workloads."
- "Cluster runs in `regular` GKE release channel — confirm acceptable vs `stable` for your risk tolerance."
- "This pattern matches the GCP Architecture Framework recommendation for X."

## Calibration rules

- **One severity per finding.** No "Critical/High" hybrids. Pick one.
- **Default to the lower tier when in doubt.** Over-reporting Critical kills signal.
- **Cross-tenant exposure is always Critical**, even if exploitation is theoretical.
- **Audit-integrity issues are at least High**, never Medium.
- **Cost-only findings are at most High** (never Critical). Cost is rarely a P0.
- **Compliance failures** — Critical only if the failure is *material* under the customer's regulatory scope. Otherwise High.
- **Reliability gaps** — Critical only if there is no working recovery path. Otherwise High or Medium.
