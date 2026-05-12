# Example 3 — Pre-apply Terraform Review

## Scenario

You are about to `terraform apply` a non-trivial change (new GCP project + new GKE cluster). You want a focused review of the proposed diff before approving the apply.

## Invocation

```
Run /gcp-architecture-best-practices-reviewer pre-apply.

Scope: the proposed Terraform diff for the new admin-app-services project + regional GKE cluster.
Categories: Architecture, Network, IAM, Security, CI/CD, Reliability, Cost.
Plan output: terraform/environments/admin-app-services/.terraform-plan.txt
Modified files: terraform/environments/admin-app-services/**
Severity floor: Medium.
CIS benchmark: concepts only, version unverified.
Output: ./reviews/$(date +%F)-admin-app-services-preapply-review.md
Read-only. No proposed remediations on disk.
```

## What the skill does

1. Reads the `terraform plan` output (create/update/destroy summary).
2. Reads each modified Terraform file.
3. Pulls 7 checklists matching the requested categories.
4. Flags every plan-time delta likely to harm production-equivalent posture.
5. Calls out anything that cannot be rolled back cleanly without state surgery.
6. Writes report.

## Expected output shape

```markdown
# GCP Architecture Pre-Apply Review — admin-app-services — 2026-05-11

## 1. Scope and Inputs
- Scope statement: Pre-apply review of new admin-app-services project + GKE cluster
- Repos / paths inspected: terraform/environments/admin-app-services/**
- Plan summary: 47 to add, 0 to change, 0 to destroy
- Categories: Architecture, Network, IAM, Security, CI/CD, Reliability, Cost
- CIS benchmark: concepts only, version unverified
- Severity floor: Medium

## 2. Executive Summary
- Total findings by severity: Critical 0, High 2, Medium 5, Low 0 (filtered out)
- Top 5 risks:
  1. GKE cluster created with public control plane endpoint
  2. Default node service account used
  3. ...
- Recommendation: HOLD apply until High findings resolved.

## 3. Evidence Map
| Review area | Primary files | Confirmed? |
|---|---|---|
| Architecture | terraform/.../project.tf, gke.tf | Y |
| Network | terraform/.../network.tf | Y |
...

## 4. Findings

### 4.2 High

## FINDING-HIGH-001: New GKE cluster created with public control plane endpoint

Severity: High

Category:
GKE

Evidence:
- File/path/resource inspected: terraform/environments/admin-app-services/gke.tf:22-34
- Relevant configuration/code/document excerpt:
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false   # public control plane
  }
- Why this is evidence: Cluster will be created with public Kubernetes API endpoint.

Problem:
The new GKE cluster's Kubernetes API endpoint will be publicly reachable. Although authorized
networks may be configured, exposing the control plane increases attack surface.

Risk:
Public control plane + any auth misconfiguration = path to cluster-wide compromise. Even with
authorized networks, IP allowlist drift over time creates exposure.

Recommendation:
Set enable_private_endpoint = true. Operator access via IAP TCP forwarding to a bastion or
via VPN. Verify the cluster admin workflow before apply, since flipping this after apply
requires a cluster recreate (destructive).

Validation:
After apply: gcloud container clusters describe <cluster> \
  --format='value(privateClusterConfig.enablePrivateEndpoint)'
Expected: True.

CIS / GCP Best Practice Mapping:
CIS GCP Foundation Benchmark concept: GKE private cluster; minimize control plane exposure.

Tradeoff:
Adds an operator-access hop (IAP / VPN / bastion). Slight friction for first-time setup.
Worth it because flipping this attribute post-apply requires cluster recreate.

Open Questions:
Is the operator-access path defined before apply? If not, define it first — do not apply
this resource without a working admin path.

## FINDING-HIGH-002: Default Compute Engine service account used by GKE nodes

Severity: High

Category:
IAM

Evidence:
- File/path/resource inspected: terraform/environments/admin-app-services/gke.tf:88
- Relevant configuration/code/document excerpt:
  # service_account not set — falls back to default Compute Engine SA
- Why this is evidence: Absence of explicit node service account.

Problem:
GKE node pool will use the project's default Compute Engine SA, which typically has roles/editor.

Risk:
Compromise of any node yields broad project access.

Recommendation:
Create a dedicated GKE node SA with minimum roles:
- roles/logging.logWriter
- roles/monitoring.metricWriter
- roles/monitoring.viewer
- roles/stackdriver.resourceMetadata.writer
- roles/artifactregistry.reader
Set service_account on the node pool.

Validation:
gcloud container node-pools describe <pool> --cluster=<cluster> \
  --format='value(config.serviceAccount)'
Expected: matches the dedicated SA, not the default compute SA.

CIS / GCP Best Practice Mapping:
CIS GCP Foundation Benchmark concept: don't use default service accounts; SA minimum privilege.

Tradeoff:
Adds one more SA to manage. Trivial vs the blast radius reduction.

Open Questions:
None.

### 4.3 Medium
[...]

## 5. Unverified Areas
[...]

## 9. Recommendations Roadmap

### Quick wins (≤ 1 day, before apply)
- Fix HIGH-001 + HIGH-002 (above).
- Fix MEDIUM-001 / 002 (audit log sinks).

### Medium-term (≤ 1 sprint)
- ...

### Long-term (architectural)
- ...

## 10. Open Questions for the Operator

- Operator-access path for private GKE control plane (IAP / VPN / bastion) — choose before apply.
- Region choice (us-central1 vs us-east4) — confirm matches data residency requirements.
- ...
```

## What to do

- Read findings.
- Apply the High fixes in the TF.
- Re-run `terraform plan`.
- Re-run this skill against the updated plan.
- Only proceed to `terraform apply` once High = 0 and you've explicitly accepted each Medium.
