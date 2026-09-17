# Learning path — toward cloud security engineering

A **free-first** roadmap. Do the free/local things until they're second nature before spending
a cent on a real cloud account.

## Stage 0 — Fundamentals (free, hosted)
- **flaws.cloud** and **flaws2.cloud** — guided AWS CTFs in the browser + AWS CLI. Teaches S3
  misconfig, IAM, instance-metadata (SSRF→creds), privilege escalation. See
  [flaws-cloud.md](flaws-cloud.md).
- Read the **AWS Well-Architected — Security Pillar** and the **shared responsibility model**.

## Stage 1 — IaC + emulated AWS (this repo, free, local)
- **Module 1 (LocalStack + Terraform):** stand up misconfigured "AWS", find the issues with
  `awslocal`, then remediate the Terraform.
- **Module 2 (IaC scanning):** run **Checkov / tfsec / Trivy** against insecure Terraform.
  This "shift-left" skill is exactly what cloud-security engineers do daily.

## Stage 2 — Containers & Kubernetes (this repo, free, local)
- **Module 3 (Kubernetes Goat):** attack and harden a cluster on **minikube**. Learn RBAC,
  network policies, secrets, admission control, image scanning with **Trivy**.

## Stage 3 — Posture management (free tools)
- **Module 4 (Prowler / ScoutSuite):** run posture scans, read the findings, map them to CIS
  benchmarks, and write remediation. Practice against LocalStack now; a real account later.

## Stage 4 — Real cloud, with guardrails (small/near-zero cost)
Only after the above. Open a **dedicated learning account**, then read
[cost-safety.md](cost-safety.md) **before** deploying anything:
- **CloudGoat** (Rhino Security Labs) — scenario-based AWS attacks.
- **IAM Vulnerable** — AWS IAM privilege-escalation paths.
- **AWSGoat / AzureGoat** — full vulnerable app stacks.

## Stage 5 — Detection & response
- Enable and read **CloudTrail**, **AWS Config**, **GuardDuty**; build a simple alert
  (EventBridge → SNS) for a risky API call. Understand log-based detection.

## Stage 6 — Certify (signal to employers)
- **AWS Certified Security – Specialty** (or **Solutions Architect Associate** first for
  fundamentals). Azure: **AZ-500**. Kubernetes: **CKS**.

## Core skills checklist
- [ ] IAM: policies, roles, trust, privilege escalation, least privilege
- [ ] Terraform: modules, state, drift, `plan`/`apply`/`destroy`
- [ ] IaC scanning: Checkov / tfsec / Trivy in CI
- [ ] Data security: encryption at rest/in transit, public-access blocks, KMS
- [ ] Network: VPC, security groups, no `0.0.0.0/0` on admin ports
- [ ] Kubernetes: RBAC, secrets, network policies, image scanning
- [ ] Detection: CloudTrail, Config, GuardDuty, log analysis
- [ ] CSPM: Prowler / ScoutSuite, CIS benchmarks
- [ ] Secrets management: no plaintext creds; use a vault/secrets manager
