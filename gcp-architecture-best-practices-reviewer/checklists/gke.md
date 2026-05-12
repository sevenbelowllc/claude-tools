# GKE / Kubernetes Checklist

## Cluster posture

- [ ] Cluster mode chosen deliberately (Autopilot vs Standard) with documented reason.
- [ ] Private cluster — nodes have no public IPs.
- [ ] Private control plane OR authorized networks list scoped to known operator IPs.
- [ ] Release channel chosen (rapid / regular / stable) and matches risk tolerance.
- [ ] Maintenance windows declared, off-business-hours.
- [ ] Cluster CMEK on etcd if required by compliance.

## Workload Identity

- [ ] Cluster-level Workload Identity enabled.
- [ ] Every KSA that calls a GCP API is bound to a GCP SA.
- [ ] `iam.gke.io/gcp-service-account` annotation present where needed.
- [ ] No node-level service account used as a workload identity shortcut.

## Pod security

- [ ] Pod Security admission `restricted` on application namespaces.
- [ ] `baseline` only with documented exception.
- [ ] `securityContext`: `runAsNonRoot: true`, `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`, `capabilities.drop: [ALL]`.
- [ ] `seccompProfile: RuntimeDefault`.
- [ ] No `hostNetwork: true`, `hostPID: true`, `hostIPC: true`.

## Network policies

- [ ] Deny-by-default NetworkPolicy per namespace.
- [ ] Explicit ingress allowlist per service.
- [ ] Explicit egress allowlist — kube-dns, sibling services, required GCP APIs.
- [ ] Cross-namespace ingress handled via additive policies, not broad allows.

## Image supply chain

- [ ] Artifact Registry only; no Docker Hub, no public registries.
- [ ] Images pinned by digest, not by mutable tag.
- [ ] Binary Authorization attestations required.
- [ ] Vulnerability scanning gates severe-or-higher findings before deploy.

## Workload sizing

- [ ] CPU + memory `requests` AND `limits` set on every container.
- [ ] HPA on every user-facing workload, with min replicas matching SLO.
- [ ] PodDisruptionBudget on every critical workload.
- [ ] Resource quotas per namespace.

## Sidecars

- [ ] Sidecars (cloud-sql-proxy, mesh proxy, secret-store) justified.
- [ ] Sidecar restart isolation considered (does app crash if sidecar restarts?).
- [ ] Sidecar resource requests sized.

## Secrets

- [ ] Secrets fetched via ESO + Workload Identity, not baked into images.
- [ ] Reloader (or equivalent) restarts pods on Secret-version change.
- [ ] No secrets in ConfigMaps.
- [ ] Secret mounts use `readOnly: true`.

## Persistent storage

- [ ] PVC sizes match projected growth + buffer.
- [ ] Volume snapshot policy defined for stateful workloads.
- [ ] CMEK on PVCs holding sensitive data.

## Cost

- [ ] Node auto-provisioning bounded by max CPU / memory.
- [ ] Idle workloads scaled to 0 in non-production.
- [ ] HPA min replicas not over-set in non-production.

## Evidence sources

- `gcloud container clusters describe <cluster>`
- `kubectl get networkpolicies -A`
- `kubectl get podsecuritypolicy` (deprecated) / `kubectl get rolebindings -n kube-system | grep psa`
- `kubectl get deployment -A -o jsonpath='...'` (for securityContext extraction)
- Helm / Kustomize manifests
- Terraform `kubernetes/` module
