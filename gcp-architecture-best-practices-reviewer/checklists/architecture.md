# Architecture Checklist

## Project topology

- [ ] Folder + project hierarchy maps to security and blast-radius boundaries.
- [ ] Separation of host network / app / data / CI/CD / admin services into distinct projects.
- [ ] Environment separation enforced at project level (nonprod / prod / sandbox).
- [ ] Cross-project IAM grants are explicit, minimal, and documented.
- [ ] No primitive roles (`roles/owner`, `roles/editor`) granted across project boundaries.

## VPC + subnet design

- [ ] Shared VPC used where multi-project topology warrants it.
- [ ] CIDR allocation has documented headroom for projected growth.
- [ ] Secondary ranges sized for GKE Pods + Services.
- [ ] Dedicated subnet for Cloud Run Direct VPC Egress (`/26` minimum; `/28` per execution reservation, ~30-60min linger after execution).
- [ ] Subnets named by purpose, not by index.

## Region + zone posture

- [ ] Workloads placed in regions consistent with data residency requirements.
- [ ] Multi-zone for HA where SLO demands it.
- [ ] Multi-region only where justified — not by default (egress cost).
- [ ] Failover behavior tested, not just declared.

## Service boundaries

- [ ] Each service has a documented "talks-to" allowlist enforced by NetworkPolicy + IAM.
- [ ] No "kitchen sink" service account shared across services.
- [ ] No public hairpin for service-to-service traffic. Cross-project routing uses PSC / Shared VPC / ILB.

## IaC discipline

- [ ] Terraform is the only sanctioned change path.
- [ ] No `gcloud` / console-driven drift in production-equivalent envs.
- [ ] State files isolated per environment.
- [ ] Module reuse over copy-paste duplication.
- [ ] Module versions pinned.

## Anti-patterns to flag

- [ ] Parallel infrastructure when canonical exists (e.g. building a new pipeline when one already runs).
- [ ] Mixed-tier storage (app data and audit data in the same bucket).
- [ ] Single service account spanning multiple trust boundaries.
- [ ] Architecture docs that disagree with shipped code.
- [ ] Org policies absent or permissive on production-equivalent projects.

## Naming + labels

- [ ] Resource names follow a documented convention.
- [ ] Labels include at minimum: `env`, `service`, `owner`, `cost-center`.
- [ ] Labels used by cost reports and incident automation.

## Evidence sources

- Architecture decision records (ADRs) / DECs
- Terraform root modules + module library
- Project / folder IAM bindings (`gcloud projects get-iam-policy`)
- VPC + subnet TF declarations
- Org policy state (`gcloud resource-manager org-policies list`)
