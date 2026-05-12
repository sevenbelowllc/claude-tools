# Reliability / DR / Scalability Checklist

## SLO / SLI

- [ ] Per critical service: availability, latency (P50/P95/P99), error rate, saturation defined.
- [ ] SLO declared with error budget.
- [ ] Burn-rate alerts (multi-window, multi-burn-rate) wired.
- [ ] Postmortem action items tracked to closure.

## Zone / region posture

- [ ] Stateful services replicate across zones for HA.
- [ ] Stateless services scale across zones with anti-affinity.
- [ ] Multi-region used only where justified by SLA / residency (cost trade).
- [ ] Failover tested, not just configured.

## Database reliability

- [ ] Cloud SQL HA = `regional` for production-equivalent tiers.
- [ ] Read replicas size + lag monitored.
- [ ] PITR enabled where required.
- [ ] **Restore tested** quarterly minimum; runbook present.
- [ ] Backup AND restore — both verified, not one or the other.

## DR

- [ ] RTO (Recovery Time Objective) declared per data class.
- [ ] RPO (Recovery Point Objective) declared per data class.
- [ ] DR runbook exists; exercise cadence defined.
- [ ] Cross-region backup copy where compliance / disaster scope requires.

## Graceful degradation

- [ ] Observability / telemetry outages MUST NOT fail user requests.
- [ ] Third-party SaaS outages have documented fallback or accepted-impact mapping.
- [ ] Circuit breakers on outbound calls to flaky dependencies.
- [ ] Timeouts set on every outbound call.

## Capacity headroom

- [ ] Subnet + secondary range IP headroom ≥ projected 12-month growth.
- [ ] GKE node range ceiling set with documented headroom.
- [ ] Cloud SQL connections vs max-connections ceiling.
- [ ] Quota usage tracked; alerts before hitting hard limits.

## Quota + limits visibility

- [ ] Quotas inventoried per project.
- [ ] Critical-quota alerts at 75% / 90%.
- [ ] Quota requests submitted for known-growth services.

## Upgrade posture

- [ ] GKE release channel matches risk tolerance.
- [ ] Maintenance windows declared, off-business-hours.
- [ ] Surge upgrade settings tuned.
- [ ] Cluster + node upgrade exercises run.

## Chaos + failure injection

- [ ] If practiced: cadence + scope documented.
- [ ] If not practiced: at least one failure mode tested manually per quarter.

## Dependency graph

- [ ] Third-party SaaS dependencies inventoried (auth, edge, monitoring, mail, payments).
- [ ] Per dependency: failure mode → user impact → fallback.
- [ ] SaaS SLA reviewed against your own SLO commitments.

## Anti-patterns to flag

- [ ] Critical service running in single zone.
- [ ] Backup configured, restore never tested.
- [ ] Single tightly-coupled dependency chain (one outage = total outage).
- [ ] `error_budget` declared but not measured.
- [ ] Quota at 95% with no growth plan.

## Evidence sources

- Cloud Monitoring SLO config + dashboards
- Cloud SQL instance config (`availabilityType: REGIONAL`)
- DR runbook documents
- Quota dashboard (`gcloud compute project-info describe` + `gcloud monitoring`)
- Alerting policy export
- Incident postmortem repo
