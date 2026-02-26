# Senior GCP Cloud Security Engineer – Practical Assessment

## Context

You are joining an existing Google Cloud organization (~25 projects) spanning production, staging, and shared environments.

Architecture characteristics:
- Shared VPC (host + service projects)
- External HTTPS Load Balancers
- API gateway (Apigee or equivalent)
- Security Command Center enabled
- Terraform used for infrastructure management
- Multiple engineering teams with varying IAM practices

You are provided configuration exports and infrastructure snippets representing the current state.

---

## Deliverables (Maximum 2 Pages)

### 1) Risk Assessment
Identify the **top 8 security risks**, ranked by severity.
For each:
- Severity (Critical / High / Medium)
- Why it is a risk
- Potential business impact

### 2) 60‑Day Remediation Plan
Outline:
- What you review first and why
- What you remediate immediately
- What you phase carefully
- Any risks you would temporarily accept (with justification)

### 3) Preventative Guardrails
List **5 organization-level guardrails** you would implement to prevent recurrence.
Specify whether each belongs in:
- IAM
- Organization Policy
- Networking / Perimeter
- CI/CD
- Logging / Monitoring

### 4) Hidden Risks
Identify **2 risks not explicitly listed in SCC findings**.

---

## Constraints

- Production systems must remain available.
- Do not redesign from scratch.
- Focus on realistic and enforceable improvements.
- Keep your response concise and structured (max 2 pages).

You will defend your reasoning in a 30-minute live discussion.
