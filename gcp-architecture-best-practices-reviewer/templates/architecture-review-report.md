# Architecture Review Report Template

Use this skeleton for the final output document. Fill section by section. Do not skip sections — write "Not in scope" if not applicable, never delete the heading.

```markdown
# GCP Architecture Review — [Scope] — [YYYY-MM-DD]

## 1. Scope and Inputs

- Scope statement:
- Repos / paths inspected:
- Environments in scope:
- CIS benchmark version (or "concepts only, version unverified"):
- Filters applied (severity floor, category filter):
- Reviewer: gcp-architecture-best-practices-reviewer
- Run date:

## 2. Executive Summary

- Total findings by severity:
  - Critical: N
  - High: N
  - Medium: N
  - Low: N
  - Informational: N
- Top 5 risks:
- Top 5 cost opportunities:
- Top 5 reliability gaps:
- Top 5 compliance gaps:
- Overall posture statement (1 paragraph):

## 3. Evidence Map

| Review area | Primary files / resources | Confirmed? |
|---|---|---|
| Architecture | ... | Y/N/Partial |
| Network | ... | Y/N/Partial |
| IAM | ... | Y/N/Partial |
| Security | ... | Y/N/Partial |
| GKE | ... | Y/N/Partial |
| Cloud SQL | ... | Y/N/Partial |
| Storage / Secrets / KMS | ... | Y/N/Partial |
| Logging / Monitoring | ... | Y/N/Partial |
| CI/CD | ... | Y/N/Partial |
| Cost | ... | Y/N/Partial |
| Reliability | ... | Y/N/Partial |
| CIS GCP alignment | ... | Y/N/Partial |

## 4. Findings

### 4.1 Critical
[Finding blocks per templates/finding.md]

### 4.2 High
[Finding blocks per templates/finding.md]

### 4.3 Medium
[Finding blocks per templates/finding.md]

### 4.4 Low
[Finding blocks per templates/finding.md]

### 4.5 Informational
[Finding blocks per templates/finding.md]

## 5. Unverified Areas

Areas that could not be evaluated this run, and the specific evidence that would be needed.

| Area | Missing evidence | How to obtain |
|---|---|---|

## 6. CIS GCP Benchmark Alignment Summary

- Version aligned against:
- Concept areas confirmed:
- Concept areas with gaps:
- Concept areas unverified:

## 7. Cost Optimization Summary

| Finding ID | Title | Impact band (S/M/L/XL) | Tradeoff |
|---|---|---|---|

## 8. Reliability and DR Summary

- Per-service SLO posture:
- DR readiness verdict per critical data store:
- Untested restore paths:
- Capacity headroom concerns:

## 9. Recommendations Roadmap

### Quick wins (≤ 1 day)
- ...

### Medium-term (≤ 1 sprint)
- ...

### Long-term (architectural)
- ...

## 10. Open Questions for the Operator

Real blockers only. No speculation.

- ...

## 11. Cross-References

- Related ADRs / DECs:
- Related prior findings:
- Related tickets / epics:

## 12. Appendix

### Commands run
```
# read-only commands only
```

### Files inspected
- ...

### Tools used
- ...
```
