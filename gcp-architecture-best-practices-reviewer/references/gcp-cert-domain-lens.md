# GCP Certification Domain Lens

The skill reasons from the body of knowledge represented by these Google Cloud certifications. The skill does not hold certifications — it applies their **domains** as a structured review lens.

## Professional Cloud Architect

| Domain | Review focus |
|---|---|
| Designing for technical, business, regulatory requirements | Trace each architectural choice to the requirement it satisfies. |
| Compute / storage / network / database service selection | Right service for the workload — managed vs self-managed, regional vs global. |
| Multi-tenant architecture | Tenancy model, isolation enforcement, blast radius. |
| HA, fault tolerance, DR | Multi-zone, multi-region, backup + tested restore, failover behavior. |
| Migration planning | Dependency mapping, cutover safety, rollback. |
| Solution lifecycle | Versioning, deprecation, decommissioning, IaC. |

## Professional Cloud DevOps Engineer

| Domain | Review focus |
|---|---|
| CI/CD pipeline design | Workload Identity Federation, branch protection, plan-only on PR, gated apply. |
| SRE — SLI / SLO / error budget | Per-service SLO defined, burn-rate alerts wired. |
| Service monitoring + incident response | Alerts mapped to runbooks; on-call exercise cadence. |
| IaC maturity | Terraform-only change path; no drift; module reuse; state isolation. |
| Deployment strategies | Canary / rolling / blue-green / feature-flag; rollback documented. |
| Continuous improvement | Observability gaps closed iteratively; postmortem actions tracked. |

## Professional Cloud Security Engineer

| Domain | Review focus |
|---|---|
| Identity / access / key management | IAM least privilege, Workload Identity, no exported SA keys, key rotation. |
| Network security | Private IP, deny-by-default firewall, Cloud Armor on external LBs, no public hairpin. |
| Workload + data security | CMEK on sensitive data, Binary Authorization on GKE, vuln scanning. |
| Audit logging + compliance evidence | All 4 audit-log categories enabled where required, exported, retained. |
| Threat detection + response | Detection rules mapped to MITRE ATT&CK cloud techniques, runbooks present. |
| Encryption in transit + at rest | TLS everywhere external; mTLS or mesh in-cluster where required; CMEK at rest. |

## Professional Cloud Network Engineer

| Domain | Review focus |
|---|---|
| VPC + Shared VPC design | Project topology, subnet sizing, secondary ranges, headroom. |
| Hybrid connectivity | VPN / Interconnect if used; private routes; DNS. |
| Network services | Cloud NAT, load balancing, DNS, Private Service Connect. |
| Network security | Firewall rules, hierarchical policies, Cloud Armor, no broad ingress. |
| Network observability | VPC Flow Logs, Firewall Insights, exported to SIEM. |
| Cost-aware design | Egress optimization, regional LB choice, PSC over public hairpin. |

## Professional Security Operations Engineer

| Domain | Review focus |
|---|---|
| Threat detection + response | Detection coverage for cloud-native attack patterns. |
| Security telemetry pipelines | Cloud Logging → SIEM; sink completeness; retention. |
| Vulnerability + posture management | Artifact Analysis, Security Command Center signals triaged. |
| Incident response readiness | Runbooks, communications, evidence preservation. |
| Forensic data retention | Append-only audit sinks, locked retention, tamper-evident. |
| Detection engineering | Custom rules for tenant-isolation breach, IAM grant changes, KMS key changes. |

## How the lens is applied

For each review area, the skill asks: "If a Cloud Architect / Cloud DevOps / Cloud Security / Cloud Network / Security Ops engineer reviewed this artifact today, what gap would they flag?" Every flagged gap becomes a candidate finding — promoted only if evidence supports it.
