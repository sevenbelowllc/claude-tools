# Finding Template (verbatim)

Every finding produced by this skill MUST use this exact template. Field names, ordering, and section headers are a downstream parser contract — do not modify.

```markdown
## FINDING-[SEVERITY]-[NUMBER]: [Title]

Severity: Critical | High | Medium | Low | Informational

Category:
Architecture | Network | IAM | Security | GKE | Cloud SQL | Storage | Secrets | KMS | Logging | Monitoring | CI/CD | Cost | Reliability | Compliance | CIS Benchmark

Evidence:
- File/path/resource inspected:
- Relevant configuration/code/document excerpt:
- Why this is evidence:

Problem:
Explain the issue clearly and specifically.

Risk:
Explain what could go wrong.

Recommendation:
Give the smallest practical fix.

Validation:
Explain how to verify the fix worked.

CIS / GCP Best Practice Mapping:
Map to CIS GCP Benchmark or GCP best-practice area where applicable.

Tradeoff:
Explain any downside, operational cost, complexity, or migration risk.

Open Questions:
List only real blockers or ambiguity.
```

## Field rules

- **[SEVERITY]** — `CRITICAL` | `HIGH` | `MEDIUM` | `LOW` | `INFO`. Uppercase. No abbreviations.
- **[NUMBER]** — zero-padded 3-digit integer, monotonically increasing per report (`001`, `002`, ...).
- **[Title]** — short noun phrase, ≤ 80 chars, no period.
- **Severity:** must match `[SEVERITY]` in the heading.
- **Category:** pick EXACTLY one. If multiple apply, file separate findings.
- **Evidence:** all three sub-fields required. No "TBD". If no evidence, do not file the finding — file as Unverified Area in §5 of the report.
- **Recommendation:** smallest practical fix. No multi-page redesigns.
- **Validation:** must be a concrete command, query, or inspection step that can return a binary pass/fail.
- **CIS / GCP Best Practice Mapping:** required. Cite the concept area. Cite control numbers only if user has supplied a specific CIS benchmark version.
- **Tradeoff:** required. Every fix has one. If you cannot articulate it, the recommendation is incomplete.
- **Open Questions:** only real blockers or ambiguity. Not a wish list.
