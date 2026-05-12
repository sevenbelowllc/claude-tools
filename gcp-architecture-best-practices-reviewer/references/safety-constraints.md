# Safety Constraints

Hard rules. Any violation is a defect in the skill itself.

## Evidence and reasoning

1. **No guessing.** If the evidence does not support the finding, do not file it.
2. **No fake citations.** Every path, line number, command, and resource ID must be real.
3. **No generic recommendations without evidence.** "Use least privilege" alone is not a finding.
4. **Always distinguish confirmed facts from assumptions.** Tag each finding `Confirmed` / `Inferred` / `Assumed`.
5. **Memory and summaries are pointers, not evidence.** Re-verify before citing.
6. **Missing evidence is not a fabricated finding.** Flag as Unverified Area in §5 of the report. Unless absence of the control itself is the issue.

## State changes

7. **No production changes.**
8. **No `terraform apply`.** Plan only.
9. **No `kubectl` mutation** — no `apply`, `delete`, `patch`, `edit`, `scale`, or `exec` with side effects.
10. **No `gcloud` mutation** — no `create`, `delete`, `update`, `set-iam-policy`, `add-iam-policy-binding`, `remove-iam-policy-binding`, etc.
11. **No `gh` mutation** beyond reading. No PR merges, no comment posting unless explicitly authorized.
12. **No destructive commands.** No `rm`, `mv` of source files, no force-pushes, no rewrites of git history.
13. **No modifying files** unless the user explicitly asks for remediation files.

## Secrets and credentials

14. **No secret reads** unless explicitly authorized for the specific finding.
15. **No credential exposure in output.** Redact tokens, keys, passwords, connection strings, signed URLs.
16. **No printing of `.env` files**, service-account JSON keys, KMS keys, or any plaintext secret.
17. **No `gcloud secrets versions access`** in output — only document that the secret exists and was accessible.

## Finding quality

18. **Do not mark an item as resolved** without validation evidence.
19. **Do not collapse security, reliability, and cost findings** into one vague finding. File one per concern.
20. **Do not recommend expensive architecture** unless the risk justifies it.
21. **Do not recommend enterprise controls** where a simpler control is sufficient.
22. **Every cost recommendation includes a tradeoff.** No exceptions.
23. **Every recommendation includes a validation step.** No exceptions.

## Compliance claims

24. **Never claim exact CIS compliance** unless: (a) user has specified the CIS benchmark version, (b) the skill has read each control's required evidence for that version, (c) the skill has inspected the GCP resource state or Terraform declaration corresponding to each control.
25. **Never claim SOC 2 / GDPR / HIPAA / PCI / ISO compliance.** This skill produces architectural findings, not compliance certifications.

## Boundary

26. **Read-only by default.** If the user explicitly opts in to remediation, the skill MAY write proposed remediation files to a user-named output path — never modify source files in place.
