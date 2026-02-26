# Senior GCP Cloud Security Engineer
**Author:** Tim  

---

After reviewing the provided configurations, I observed a consistent pattern:

> The environment has good foundational tooling (SCC, Terraform, Org Policies), but enforcement gaps create elevated blast radius in production.

My priority is reducing catastrophic compromise risk first, then minimizing exposure, and finally hardening governance — without disrupting production systems.

---

# 1) Risk Assessment – Top 8 (Ranked by Business Impact)

| # | Finding (Evidence) | Severity | Practical Justification | Business Impact |
|---|-------------------|----------|--------------------------|----------------|
| 1 | `roles/owner` assigned to `cicd@prod-payments` | **CRITICAL** | If the CI/CD pipeline is compromised (token leak, supply-chain attack, misconfigured runner), the attacker inherits full project control including IAM modification. In production, this is unacceptable blast radius. | Complete production takeover, data exfiltration, infrastructure destruction |
| 2 | `disableServiceAccountKeyCreation = false` | **CRITICAL** | Allowing service account keys enables long-lived credentials that can be downloaded and reused outside Google’s identity boundary. This defeats centralized IAM control and modern keyless security practices. | Persistent unauthorized access and difficult-to-detect breaches |
| 3 | Firewall allows `0.0.0.0/0 → tcp:22` | HIGH | Internet-facing SSH is one of the most common intrusion vectors. Even strong passwords don’t eliminate brute-force risk. In a Shared VPC environment, compromise of one VM increases lateral movement risk. | Initial foothold leading to lateral compromise |
| 4 | `compute.vmExternalIpAccess` unrestricted | HIGH | Developers can provision public VMs outside centralized ingress controls (LB/WAF). This creates shadow exposure that bypasses security inspection layers. | Expanded attack surface and potential data leakage |
| 5 | Terraform WAF policy allows all traffic | HIGH | A security policy exists but enforces nothing. This creates a false sense of protection for internet-facing load balancers, especially in a payments context. | OWASP attacks, fraud exposure |
| 6 | Data Access Logs Disabled | MEDIUM | Without data access logs, sensitive read operations are invisible. During an incident, forensic reconstruction becomes guesswork. | Delayed breach detection and compliance risk |
| 7 | `roles/editor` at prod folder | MEDIUM | Editor grants broad mutation permissions across production. This increases both accidental outage risk and privilege escalation paths. | Production instability and governance weakness |
| 8 | `compute.requireOsLogin = false` | MEDIUM | SSH keys can be manually injected into VMs, bypassing centralized IAM controls. This reduces accountability and audit traceability. | Weak access governance |

---

# 2) 60-Day Remediation Plan

## Strategy

My approach is simple:

1. Reduce catastrophic blast radius immediately  
2. Minimize external exposure  
3. Institutionalize preventative guardrails  

All changes are staged to avoid production downtime.

---

## Phase 1 – Immediate Risk Containment (Days 0–14)

| Action | Why This First |
|--------|----------------|
| Remove `roles/owner` from CI/CD SA | Eliminates single biggest takeover vector |
| Enforce `disableServiceAccountKeyCreation` | Stops new long-lived credentials immediately |
| Remove public SSH; implement Identity-Aware Proxy (IAP) | Closes direct internet entry point |
| Enforce OS Login | Centralizes SSH access governance |

This phase focuses strictly on eliminating high-blast-radius compromise paths.

---

## Phase 2 – Attack Surface Reduction (Days 15–30)

| Action | Objective |
|--------|----------|
| Restrict external IP allocation via Org Policy | Prevent uncontrolled public VM exposure |
| Implement real Cloud Armor WAF rules | Protect public load balancers at Layer 7 |
| Enable Data Access Logging (prod first) | Restore investigative visibility |
| Audit Shared VPC firewall inheritance | Reduce lateral movement paths |

At this stage, we reduce exposure while maintaining service continuity.

---

## Phase 3 – Governance Hardening (Days 30–60)

| Action | Goal |
|--------|------|
| Replace Editor with least-privilege custom roles | Enforce proper separation of duties |
| Implement IAM Conditions | Context-aware access control |
| Add Terraform policy validation (pre-merge checks) | Prevent risky IAM grants before deployment |
| Operationalize SCC findings into workflow | Shift from reactive to proactive posture |

This phase ensures sustainability, not just remediation.

---

## Temporary Risk Acceptance

| Risk | Justification |
|------|--------------|
| Increased logging costs | Detection capability outweighs cost impact |
| Gradual IAM tightening | Avoid disrupting engineering velocity |

Security improvements must not break production systems.

---

# 3) Preventative Guardrails (Organization-Level)

| Guardrail | Category | Outcome |
|-----------|----------|--------|
| Disable Service Account Key Creation | Organization Policy | Eliminates unmanaged credentials |
| Enforce OS Login + IAP-only SSH | IAM / Networking | Removes direct SSH exposure |
| Restrict Public IP Allocation | Networking / Perimeter | Reduces attack surface |
| CI/CD Least Privilege Framework | CI/CD | Prevents pipeline abuse |
| Mandatory Data Access Logging | Logging / Monitoring | Enables forensic readiness |

These guardrails convert one-time fixes into enforceable policy.

---

# 4) Hidden Risks (Not Identified in SCC)

| Risk | Practical Concern |
|------|-------------------|
| `/public/**` API route without authentication | If sensitive endpoints are misclassified under this route, they may be publicly exposed without OAuth enforcement. |
| Broad Terraform IAM binding (`roles/editor`) | Infrastructure-as-code can institutionalize overprivilege if not governed, making risk systemic rather than accidental. |

---

# Final Assessment

The organization has strong security tooling in place, but enforcement inconsistencies create unnecessary exposure in production.

By prioritizing privilege reduction, exposure minimization, and policy-level guardrails, the environment can significantly reduce breach likelihood within 60 days — without architectural redesign or service disruption.

This approach balances security maturity with operational continuity.
