# Cloud SQL / Database Checklist

## Network exposure

- [ ] Private IP only (`ipv4Enabled: false` OR public IP disabled and not authorized for any range).
- [ ] No `0.0.0.0/0` in `authorizedNetworks`.
- [ ] Cloud SQL on a peered VPC range (Private Service Access).
- [ ] No public hairpin path from in-cluster workloads to the DB.

## Authentication

- [ ] IAM database authentication enabled where supported.
- [ ] PostgreSQL roles mapped to GCP SAs via `cloudsql.iam.serviceAccount` user type.
- [ ] No static `postgres` superuser password used by application workloads.
- [ ] Default users (`postgres`, `root`) — passwords rotated and stored in Secret Manager; not used by app code.
- [ ] SSL/TLS required (`requireSsl: true`).

## Connection pattern

- [ ] Cloud SQL Auth Proxy used (sidecar OR in-process connector) with `--auto-iam-authn` and `--private-ip`.
- [ ] Or direct private-IP connection with token-refreshing client library.
- [ ] Connection pooling sized to instance tier and projected concurrency.

## Backups + recovery

- [ ] Automated backups enabled.
- [ ] Point-in-time recovery (PITR) enabled for tenant-data-bearing instances.
- [ ] Backup retention meets compliance + business recovery requirement.
- [ ] **Restore tested**, not just configured. Restore runbook present.
- [ ] Backup encryption with CMEK if required.

## High availability

- [ ] HA (`regional` availability) enabled for production-equivalent tiers.
- [ ] Failover behavior verified.
- [ ] Read replicas sized to actual read load (not "just in case").
- [ ] Replica lag monitored + alerted.

## Database flags + audit

- [ ] `log_connections`, `log_disconnections`, `log_statement` (ddl or mod) set per compliance posture.
- [ ] `cloudsql.iam_authentication = on` where IAM DB auth used.
- [ ] pgaudit enabled where audit-trail required.
- [ ] Log redaction for tenant PII fields.

## Storage

- [ ] Auto-resize enabled; max storage size capped to bound runaway cost.
- [ ] Storage encryption (default Google-managed OR CMEK per posture).

## Tenant isolation (multi-tenant systems)

- [ ] RLS policies on tenant-scoped tables.
- [ ] Application sets per-request session GUC (`SET LOCAL app.tenant_id = ...`) inside a transaction.
- [ ] BYPASSRLS pool exists separately for system / migration paths; not reachable from user-request handlers.
- [ ] Cross-tenant query tests exist.

## Cost

- [ ] Machine tier vs P95 utilization reviewed quarterly.
- [ ] HA cost vs actual availability SLA need.
- [ ] PITR retention vs business recovery need (longer retention = more cost).
- [ ] Read replica count vs actual read load.

## Evidence sources

- `gcloud sql instances describe <instance>`
- `gcloud sql users list --instance=<instance>`
- `gcloud sql backups list --instance=<instance>`
- Terraform `database/` module
- App-side connection-pool config
- Migration repository (look for BYPASSRLS / `SET LOCAL` patterns)
