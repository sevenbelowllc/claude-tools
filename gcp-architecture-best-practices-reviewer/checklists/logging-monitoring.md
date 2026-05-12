# Logging / Monitoring / Detection Checklist

## Cloud Audit Logs

- [ ] Admin Activity logs — enabled (always-on default; confirm not exempted).
- [ ] Data Access logs — enabled on sensitive services: Cloud SQL, GCS, KMS, Secret Manager, BigQuery, IAM.
- [ ] System Event logs — enabled (always-on default).
- [ ] Policy Denied logs — enabled.
- [ ] No principals in `auditLogConfigs.exemptedMembers` for production-equivalent projects.

## Log sinks + retention

- [ ] Sink to long-retention GCS bucket (locked retention) for audit logs.
- [ ] Sink to SIEM (Sumo Logic / Splunk / Chronicle / equivalent) for detection.
- [ ] Retention ≥ 365 days for audit-relevant logs.
- [ ] Retention longer for compliance-bound categories (HIPAA 7y, SOX 7y, etc.) where applicable.
- [ ] Log Router sink filters not over-broad (cost) and not over-narrow (gaps).

## Network observability

- [ ] VPC Flow Logs enabled on subnets carrying sensitive workloads.
- [ ] Flow Logs sampling rate justified.
- [ ] Firewall Insights reviewed periodically.

## Application logs

- [ ] Structured JSON logs (not plain text).
- [ ] Tenant ID tagged on every log line in multi-tenant systems.
- [ ] No secrets in logs (tokens, keys, passwords).
- [ ] No raw PII in plaintext if compliance restricts it.
- [ ] Log levels: production = INFO or WARN default; DEBUG gated.

## Metrics + SLOs

- [ ] SLIs defined per critical service: availability, latency (P50/P95/P99), error rate, saturation.
- [ ] SLOs declared with error budgets.
- [ ] SLO burn-rate alerts wired (multi-window, multi-burn-rate).
- [ ] Custom metrics carry low-cardinality labels (no per-request unique values).

## Alerting

Alert on at minimum:

- [ ] Project ownership change
- [ ] IAM grant changes on sensitive bindings
- [ ] VPC + firewall rule changes
- [ ] Route + DNS zone changes
- [ ] KMS key changes (create / disable / destroy)
- [ ] Cloud SQL instance config + flag changes
- [ ] GCS bucket IAM changes
- [ ] Secret Manager secret version access on top-tier secrets
- [ ] SLO burn-rate breach
- [ ] Authentication failure spikes
- [ ] Unauthorized API calls (`Policy Denied` log spikes)

## Detection engineering

- [ ] Detection rules mapped to MITRE ATT&CK Cloud Matrix techniques.
- [ ] Tenant-isolation-breach detection rules (if multi-tenant).
- [ ] Sensitive-data-access detection rules.
- [ ] Detection rule false-positive rate tracked.

## Incident response

- [ ] Runbooks linked from every paging alert.
- [ ] On-call rotation defined.
- [ ] Postmortem cadence + action-tracking in place.

## Evidence sources

- `gcloud logging sinks list --project=<project>`
- `gcloud logging buckets list --location=<region>`
- `gcloud monitoring policies list`
- `gcloud monitoring services list`
- SIEM config (Sumo Logic / Splunk / Chronicle export)
- Terraform `observability/` module
