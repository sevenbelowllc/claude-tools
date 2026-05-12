# Cost Optimization Checklist

**Every cost recommendation MUST include a tradeoff. No exceptions.**

## GKE

- [ ] Workload `requests` match P95 actual utilization (not P50, not theoretical max).
- [ ] HPA min replicas not over-set in non-production.
- [ ] Idle deployments removed.
- [ ] Orphaned namespaces removed.
- [ ] PVCs sized to actual usage + buffer; oversized PVCs flagged.
- [ ] Node auto-provisioning bounded by max CPU / memory ceiling.
- [ ] Spot / preemptible nodes considered for fault-tolerant workloads.

## Cloud SQL

- [ ] Machine tier matches actual P95 CPU + memory utilization.
- [ ] HA tier justified by SLA, not "just in case".
- [ ] Storage auto-resize ceiling set to bound runaway cost.
- [ ] PITR retention matches business recovery need (longer = more cost).
- [ ] Read replica count matches actual read load.
- [ ] Old database snapshots / on-demand backups pruned.

## Logging ingestion

- [ ] DEBUG-level logging not enabled in production.
- [ ] High-cardinality log fields removed or aggregated.
- [ ] Duplicate sinks (e.g. shipping the same logs to two SIEMs) reviewed.
- [ ] Log Router exclusion filters in place for noisy / low-value paths (health checks, readiness probes).

## Cloud Storage

- [ ] Lifecycle policies in place: transition to Nearline (30d) → Coldline (90d) → Archive (365d) where appropriate.
- [ ] Orphaned buckets deleted.
- [ ] Object versioning retention bounded.
- [ ] Multi-region storage justified (vs regional or dual-region).

## Artifact Registry

- [ ] Image retention policy — keep last N + tagged + delete untagged after T days.
- [ ] Large unused image history pruned.

## Network

- [ ] NAT egress reviewed; high-egress destinations identified.
- [ ] Egress to repeated destinations cached or replaced with PSC where feasible.
- [ ] Egress across regions minimized.
- [ ] LB count: one fronting LB per externally-exposed service is normal; orphan LBs flagged.

## Observability + telemetry

- [ ] Sentry / DataDog / LangFuse ingest volume reviewed against utility.
- [ ] Synthetic monitor frequency vs needed signal.
- [ ] High-cardinality custom metrics dropped.

## Non-production scheduling

- [ ] Nonprod GKE node pool scales to 0 off-hours where possible.
- [ ] Nonprod Cloud SQL stopped overnight where compliance + reload time allow.
- [ ] Nonprod Cloud Run min instances = 0.

## Unused resources

- [ ] Reserved IPs in use.
- [ ] Persistent disks attached.
- [ ] Cloud SQL instances not idle.
- [ ] Cloud Run revisions cleaned up (only N most recent kept).
- [ ] Container images: tagged + recent kept.

## Region + zone placement

- [ ] Workloads collocated to minimize inter-zone + inter-region egress.
- [ ] Data + compute in same region where latency + residency permits.

## Backup retention

- [ ] Backup retention matches compliance requirement, not "safe default".
- [ ] Backup storage tier matches access pattern (rare access → Archive).

## Impact bands (recommended)

| Band | Monthly USD | Examples |
|---|---|---|
| S | < $50 | Cosmetic / hygiene |
| M | $50–$500 | Right-sizing one service |
| L | $500–$5k | Right-sizing whole tier, log volume cuts |
| XL | > $5k | Architecture-level (region collocation, schema redesign) |

## Tradeoff template

Every cost recommendation includes:

```
Tradeoff: [downside, operational cost, complexity, or migration risk]
```

Examples:

- "Right-sizing Cloud SQL from `db-custom-8-32` to `db-custom-4-16` saves ~$X/mo. Tradeoff: less headroom for traffic spikes; mitigate with HPA + read replica."
- "Enabling lifecycle Nearline transition at 30d saves ~$Y/mo on docs bucket. Tradeoff: 0.4¢/GB retrieval cost on access older than 30d."
- "Scaling nonprod GKE to 0 overnight saves ~$Z/mo. Tradeoff: ~5min cold-start when first engineer logs in next morning."

## Evidence sources

- Billing export → BigQuery → cost-by-service / cost-by-label
- `gcloud monitoring metrics` for utilization data
- `gcloud sql instances list` + `gcloud monitoring time-series list`
- GKE Usage Metering enabled?
- Artifact Registry size by repo
- Log Router sink volumes
