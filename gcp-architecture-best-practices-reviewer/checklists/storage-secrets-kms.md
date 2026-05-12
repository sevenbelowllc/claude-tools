# Storage / Secrets / KMS Checklist

## Cloud Storage

- [ ] Uniform Bucket-Level Access (UBLA) enabled on all buckets.
- [ ] Public access prevention enforced at org-policy level (`storage.publicAccessPrevention=enforced`).
- [ ] No `allUsers` / `allAuthenticatedUsers` IAM grants on any bucket.
- [ ] CMEK on sensitive buckets (tenant data, audit logs, evidence, signed-URL targets).
- [ ] Object versioning on audit-log buckets; versioning retention defined.
- [ ] Object lifecycle policies to transition cold data + delete after retention.
- [ ] Bucket-level IAM minimal; project-level `roles/storage.admin` avoided.
- [ ] Signed URLs use short TTLs (≤ 15 min typical) and scoped permissions.
- [ ] Signed URLs scoped to a single object, never to a prefix unless required.
- [ ] If a clean / unscanned / quarantined pipeline exists, transitions are auditable and reversible.

## Bucket retention + immutability

- [ ] Audit-log buckets have **locked** retention policies (cannot be reduced).
- [ ] Bucket lock applied where regulatory retention is required.
- [ ] Soft delete configured where accidental deletion is a concern.

## Secret Manager

- [ ] Secrets tiered by trust (app vs data vs admin); cross-tier access requires explicit binding.
- [ ] Rotation cadence defined; automated where possible.
- [ ] Replication policy chosen deliberately (regional vs automatic).
- [ ] Audit logging enabled for `secretmanager.secretVersionAccess` on sensitive secrets.
- [ ] Access via Workload Identity; no exported SA keys reading GSM.
- [ ] Secret values never logged or echoed by accessing workloads.

## KMS

- [ ] CMEK per data tier; not a single org-wide key.
- [ ] Key rotation period set (90 days typical for production).
- [ ] Separate `keyRing` per environment AND per tier.
- [ ] IAM on keys minimal — `roles/cloudkms.cryptoKeyEncrypterDecrypter` only.
- [ ] `cloudkms.admin` not granted to workload service accounts.
- [ ] Destruction protection (`destroyScheduledDuration` ≥ 30 days) on production keys.
- [ ] HSM-backed keys for highest-sensitivity tiers if required.

## Cross-references

- KMS keys referenced by GCS buckets, Cloud SQL instances, BigQuery datasets, Secret Manager secrets, and disks should be inventoried.
- A single key SHOULD NOT span multiple environments.

## Evidence sources

- `gcloud storage buckets list`
- `gcloud storage buckets describe gs://<bucket>` (PAP, UBLA, CMEK, lifecycle)
- `gcloud storage buckets get-iam-policy gs://<bucket>`
- `gcloud secrets list`
- `gcloud secrets describe <secret>`
- `gcloud kms keyrings list --location=<region>`
- `gcloud kms keys list --keyring=<ring> --location=<region>`
- `gcloud kms keys get-iam-policy <key> --keyring=<ring> --location=<region>`
- Terraform `storage/`, `security/`, `kms/` modules
