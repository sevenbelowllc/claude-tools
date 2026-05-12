# Security Checklist

## Encryption

- [ ] TLS for all external endpoints. HTTP redirects to HTTPS.
- [ ] mTLS or service mesh between services where required by threat model.
- [ ] CMEK on sensitive data tiers (tenant data, audit logs, evidence, KMS-protected GCS).
- [ ] CMEK key rotation period set (≤ 90 days typical).
- [ ] Per-environment + per-tier key separation; no single org-wide key for everything.

## Workload identity + secret handling

- [ ] Every workload that talks to a GCP API uses Workload Identity, not exported keys.
- [ ] No plaintext secrets in Terraform state, git, container images, or env-var dumps.
- [ ] Secrets fetched from Secret Manager via Workload Identity at runtime.
- [ ] External Secrets Operator (or equivalent) syncs GSM → k8s Secret with reload-on-change.
- [ ] Test fixtures use literal `PLACEHOLDER_*` strings, never realistic-looking keys.

## Edge + WAF

- [ ] Cloud Armor policies attached to external LBs.
- [ ] WAF rules: SQLi / XSS / OWASP top-N preconfigured rules enabled.
- [ ] Rate limiting on auth endpoints.
- [ ] Geo-restrictions documented where used.
- [ ] Bot management posture decided (allow / challenge / block).

## Container + workload security

- [ ] Binary Authorization required on production-equivalent GKE clusters.
- [ ] Artifact Analysis vulnerability scanning enabled on all Artifact Registry repos.
- [ ] Images pinned by digest in deploy manifests, not by mutable tag.
- [ ] Containers run non-root, read-only root FS, `drop: ALL` capabilities, `seccompProfile: RuntimeDefault`.
- [ ] Distroless or minimal base images.
- [ ] Pod Security admission `restricted` on application namespaces.

## Public exposure audit

- [ ] No `0.0.0.0/0` reachable management endpoints.
- [ ] No public Cloud SQL instances.
- [ ] GKE control plane private OR gated by authorized networks.
- [ ] Cloud Run services that are internal-only have `--ingress=internal` or `--ingress=internal-and-cloud-load-balancing`.
- [ ] Storage buckets have Public Access Prevention enforced.

## Tenant isolation (multi-tenant systems only)

- [ ] Tenant-scoped tables enforce RLS where tenancy is row-level.
- [ ] BYPASSRLS pool usage is restricted, separated from user-request pools, audited.
- [ ] No request path leaks `tenant_id` from one tenant to another.
- [ ] Cross-tenant test cases exist and pass.

## Detection

- [ ] Security Command Center signals triaged.
- [ ] Detection rules mapped to MITRE ATT&CK cloud techniques.
- [ ] Alerts on IAM grant changes, KMS key changes, firewall changes, VPC changes, project ownership changes, Cloud SQL flag changes, storage IAM changes.

## Evidence sources

- Terraform security module
- `gcloud kms keys list`
- `gcloud secrets list`
- `gcloud container clusters describe <cluster>` (BinAuthz, Workload Identity)
- `gcloud artifacts vulnerabilities list-occurrences`
- Cloud Armor policy TF
- Cloud Run / GKE manifests for `securityContext`
