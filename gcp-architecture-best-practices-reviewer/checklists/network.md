# Network Checklist

## VPC + connectivity

- [ ] Default network removed or unused.
- [ ] Auto-mode VPC not used in production-equivalent envs.
- [ ] Shared VPC topology documented if used; service-project bindings reviewed.
- [ ] VPC peering / VPN / Interconnect declared and necessary; not orphaned.
- [ ] Private Google Access enabled on subnets that need to reach Google APIs without public egress.

## Firewall

- [ ] Deny-by-default posture.
- [ ] No `0.0.0.0/0` ingress on sensitive ports (22, 3389, 5432, 3306, 6379, 27017, 9200).
- [ ] No `0.0.0.0/0` ingress to admin / management planes (Kubernetes API, etcd, control panels).
- [ ] Hierarchical firewall policies used for org-wide guardrails where applicable.
- [ ] Firewall rules tagged + documented.
- [ ] No "temporary" firewall rules without expiration.

## NAT + egress

- [ ] Cloud NAT used for egress instead of public IPs on VMs / pods.
- [ ] NAT logging enabled at the level required for incident response.
- [ ] Egress NAT sized; per-VM port allocation reviewed for high-fanout workloads.
- [ ] Egress destinations reviewed for cost (egress to same region cheapest).

## Load balancing

- [ ] External LBs are HTTPS with managed certs; HTTP redirects to HTTPS.
- [ ] Cloud Armor policies attached to external LBs.
- [ ] Internal LBs (`INTERNAL_MANAGED` / `INTERNAL_SELF_MANAGED`) used for service-to-service traffic — never external for internal callers.
- [ ] NEG configuration correct for the backend type (GKE, Cloud Run, serverless).
- [ ] Health checks scoped to backend paths, not to general endpoints.

## Private Service Connect

- [ ] PSC used for cross-project / cross-VPC service consumption — no public hairpin.
- [ ] Service attachment accept lists scoped to known consumer projects.
- [ ] PSC endpoint DNS resolves to internal IPs only.

## Cloudflare / external edge (if applicable)

- [ ] External DNS records proxied where the edge provides value (WAF, DDoS, caching).
- [ ] Cloudflare Access policies gate any human-facing internal UI.
- [ ] Cloudflare Tunnel used for ingress only when outbound-only is needed; tunnel-to-internal-target paths documented.

## Observability

- [ ] VPC Flow Logs enabled on subnets carrying sensitive workloads.
- [ ] Flow Log sampling rate reviewed (cost vs forensic completeness).
- [ ] Firewall Insights reviewed periodically; shadowed rules and overly-permissive rules removed.

## Hard rule

- [ ] **No public hairpin for service-to-service traffic.** Cross-project routing uses PSC / Shared VPC / ILB. Public + edge-auth is for human-facing UI only.

## Evidence sources

- `gcloud compute networks list / describe`
- `gcloud compute firewall-rules list`
- `gcloud compute routers list / describe` (Cloud NAT)
- `gcloud compute forwarding-rules list`
- Terraform network module
- VPC Flow Log sink config
