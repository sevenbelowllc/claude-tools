# CIS GCP Foundation Benchmark — Alignment Checklist

> **MUST NOT claim exact CIS compliance** unless (1) user has specified the CIS benchmark version, (2) skill has read each control's required evidence for that version, (3) skill has inspected the corresponding GCP resource state or Terraform declaration. Otherwise phrase findings as alignment against CIS **concepts**, version unverified.

## IAM

- [ ] No primitive roles (`roles/owner`, `roles/editor`, `roles/viewer`) on production-equivalent projects.
- [ ] Service account user role minimized.
- [ ] No user-managed service account keys where Workload Identity / Federation works.
- [ ] Service accounts have minimum-necessary privileges.
- [ ] Cloud KMS keys are not publicly accessible.
- [ ] Separation of duties between deployer / auditor / approver.
- [ ] MFA enforced for human principals.
- [ ] Corporate login credentials, not personal emails.

## Audit logging

- [ ] Cloud Audit Logging — Admin Activity, Data Access, System Event, Policy Denied enabled where applicable.
- [ ] No exempted principals on production-equivalent projects.
- [ ] Sinks configured for long-retention storage AND SIEM.
- [ ] Retention meets compliance window.

## Networking

- [ ] Default network does not exist OR is restricted.
- [ ] Auto-mode VPCs not in production-equivalent envs.
- [ ] Firewall rule `0.0.0.0/0` not allowed for SSH (22) or RDP (3389).
- [ ] Firewall rule `0.0.0.0/0` not allowed for database ports.
- [ ] VPC Flow Logs enabled on sensitive subnets.
- [ ] DNSSEC enabled on Cloud DNS managed zones.
- [ ] No legacy networks.

## Compute / VM

- [ ] OS Login enabled (`compute.requireOsLogin`).
- [ ] Default service account not used by VMs handling sensitive data.
- [ ] Default service account does not have `roles/editor`.
- [ ] Block project-wide SSH keys at instance level for sensitive workloads.
- [ ] Serial port access disabled (`serial-port-enable=false`).
- [ ] IP forwarding disabled unless required.
- [ ] Shielded VM enabled (vTPM + integrity monitoring).

## Cloud SQL

- [ ] Private IP only; public IP disabled.
- [ ] `requireSsl: true`.
- [ ] No `0.0.0.0/0` authorized network.
- [ ] Backups enabled.
- [ ] Database flags per CIS: `log_connections`, `log_disconnections`, `log_statement = 'ddl'` (or stricter), `log_min_messages`, `log_error_verbosity`, `log_min_duration_statement`, `log_hostname`.
- [ ] Cross-DB ownership chaining disabled (SQL Server only).
- [ ] No default `postgres` / `root` password reuse across instances.

## Cloud Storage

- [ ] Uniform Bucket-Level Access enabled.
- [ ] No `allUsers` or `allAuthenticatedUsers` IAM bindings.
- [ ] Public Access Prevention enforced at org policy level.
- [ ] Bucket logging enabled where required for audit.
- [ ] Object versioning enabled on audit-retention buckets.

## KMS

- [ ] CMEK rotation period ≤ 90 days.
- [ ] KMS keys not publicly accessible.
- [ ] Separation of `keyRing` per environment.

## BigQuery (if used)

- [ ] Datasets not publicly accessible.
- [ ] Default encryption uses CMEK for sensitive datasets.

## Monitoring + alerting

- [ ] Log metrics + alerts for:
  - Project ownership assignment / change
  - Audit Config changes
  - Custom role changes
  - VPC network changes
  - VPC firewall rule changes
  - VPC route changes
  - Cloud Storage IAM permission changes
  - SQL instance configuration changes
  - KMS key changes

## Organization policies

- [ ] `iam.disableServiceAccountKeyCreation` enforced.
- [ ] `iam.allowedPolicyMemberDomains` restricted to organization domains.
- [ ] `compute.requireOsLogin` enforced.
- [ ] `compute.skipDefaultNetworkCreation` enforced.
- [ ] `compute.vmExternalIpAccess` restricted.
- [ ] `storage.publicAccessPrevention` enforced.
- [ ] `sql.restrictPublicIp` enforced.
- [ ] `sql.restrictAuthorizedNetworks` enforced.

## Output phrasing

When generating findings against this checklist:

- If user has NOT supplied a CIS benchmark version: phrase as "Aligned against CIS GCP Foundation Benchmark **concept**: [area]. Version compliance not verified."
- If user HAS supplied a version: cite specific control numbers (e.g. "CIS GCP v3.0.0 §1.4").
- Never write "CIS compliant" or "CIS-compliant" without §9 conditions met.

## Evidence sources

- `gcloud organizations policies list --organization=<org>`
- `gcloud projects get-iam-policy <project>`
- `gcloud logging metrics list`
- `gcloud monitoring policies list`
- All evidence sources from other checklists in this directory
