# IAM + Service Accounts Checklist

## Primitive roles

- [ ] No `roles/owner` on production-equivalent projects (except break-glass, audited).
- [ ] No `roles/editor` on production-equivalent projects.
- [ ] No `roles/viewer` granted broadly when a predefined role is narrower.

## Service accounts

- [ ] One service account per workload trust boundary. No SA shared across services.
- [ ] Service account names map to the workload (no generic `default-sa`).
- [ ] No service account JSON keys created for in-cluster workloads — use Workload Identity.
- [ ] If JSON keys exist, document why, who has access, and rotation cadence.
- [ ] `iam.disableServiceAccountKeyCreation` org policy enforced where feasible.
- [ ] No SA acts as a principal across projects without explicit cross-project binding.

## Workload Identity

- [ ] GKE clusters have Workload Identity enabled.
- [ ] Each KSA that talks to a GCP API is bound to a GCP SA via `roles/iam.workloadIdentityUser`.
- [ ] KSA annotations include `iam.gke.io/gcp-service-account`.
- [ ] Cross-project WI bindings explicitly granted and tested end-to-end.

## Custom roles

- [ ] Custom roles defined where predefined roles are too broad.
- [ ] Custom role permissions list reviewed for minimum-necessary scope.
- [ ] Custom roles versioned; deprecation path documented.

## Human IAM

- [ ] Human principals are group-based, not direct user bindings.
- [ ] MFA enforced for human principals via org policy or external IdP.
- [ ] Break-glass / emergency access path documented, audited, alarmed.
- [ ] Time-bound IAM grants used for sensitive elevation.

## Separation of duties

- [ ] Deployer principal cannot also clear / mutate audit logs.
- [ ] Reviewer cannot self-approve sensitive workflow transitions.
- [ ] Production deploy permission is distinct from production data-access permission.

## Recommender + posture

- [ ] IAM Recommender output reviewed; over-grants triaged.
- [ ] Excess-permission flags tracked, not ignored.

## Anti-patterns to flag

- [ ] `serviceAccountUser` grant given broadly.
- [ ] `roles/iam.securityAdmin` granted outside the security org / break-glass.
- [ ] Project-level `roles/storage.admin` when bucket-level would suffice.
- [ ] Cross-project SA usage with no documentation.

## Evidence sources

- `gcloud projects get-iam-policy <project>`
- `gcloud iam service-accounts list`
- `gcloud iam service-accounts get-iam-policy <sa>`
- `gcloud iam service-accounts keys list --iam-account=<sa>`
- `gcloud resource-manager org-policies list --organization=<org>`
- `gcloud recommender recommendations list --recommender=google.iam.policy.Recommender`
- Terraform IAM module
