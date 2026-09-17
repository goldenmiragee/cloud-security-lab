<!-- markdownlint-disable MD033 MD041 -->
<h1 align="center">☁️🛡️ cloud-security-lab</h1>

<p align="center">
  <strong>A free, self-contained lab for learning cloud security engineering.</strong><br>
  Intentionally-misconfigured infrastructure-as-code you break <em>and</em> fix — running
  entirely on your own machine (LocalStack + minikube), with <strong>no cloud account and no bill</strong>.
</p>

<p align="center">
  <img alt="AWS (LocalStack)" src="https://img.shields.io/badge/AWS-LocalStack-FF9900?logo=amazonaws&logoColor=white">
  <img alt="Terraform"       src="https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform&logoColor=white">
  <img alt="Kubernetes"      src="https://img.shields.io/badge/K8s-Goat-326CE5?logo=kubernetes&logoColor=white">
  <img alt="Checkov"         src="https://img.shields.io/badge/Scan-Checkov%20%2F%20tfsec%20%2F%20Trivy-2EC5CE">
  <img alt="Cost"            src="https://img.shields.io/badge/Cost-%240%20(local)-brightgreen">
  <img alt="License"         src="https://img.shields.io/badge/License-MIT-blue">
</p>

---

> ### ⚠️ Ethics & Cost
> Every configuration here is **intentionally insecure**, for learning. The default path is
> **100% local and free** (LocalStack emulates AWS; minikube runs Kubernetes) — **no cloud
> account, no charges**. If you later adapt any module to a real cloud account, do it only in
> an account you own, set a **budget alarm first**, and `destroy` when done. Never deploy these
> misconfigurations to production.

---

## Why this exists

I'm building toward **cloud security engineering**, so I wanted a hands-on lab that teaches
both halves of the job:

- **Offensive** — find the misconfigurations (public buckets, over-permissive IAM, open
  security groups, plaintext secrets, insecure containers).
- **Defensive / engineering** — the part employers pay for: fix them, and catch them
  automatically with **infrastructure-as-code scanning** and **cloud posture management**.

It runs free on a laptop, so I can practice daily without touching a billable account.

## Modules

| # | Module | What you practice | Cost |
|---|--------|-------------------|------|
| 1 | [LocalStack + Terraform](modules/01-localstack-aws/) | Deploy & exploit misconfigured "AWS" (S3, IAM, EC2/SG, secrets), then remediate | $0 local |
| 2 | [IaC static analysis](modules/02-iac-security/) | Scan insecure Terraform with **Checkov / tfsec / Trivy** (shift-left) | $0 local |
| 3 | [Kubernetes Goat](modules/03-kubernetes-goat/) | Container & K8s attack/defense on minikube | $0 local |
| 4 | [CSPM: Prowler / ScoutSuite](modules/04-cspm-prowler/) | Cloud posture scanning + a findings writeup | $0 local* |

<sub>*CSPM tools run free; scanning a *real* account is optional and deferred until you have one with guardrails.</sub>

Plus **[flaws.cloud](docs/flaws-cloud.md)** — a free hosted AWS CTF (nothing to install) to do first.

## Quick start (works on macOS or Windows)

**Prerequisites** — install once (see [`tools/check-prereqs.sh`](tools/check-prereqs.sh)):
```bash
# macOS (Homebrew) — recommended, this is where you'll work.
brew tap hashicorp/tap
brew install git awscli kubectl minikube trivy colima docker docker-compose pipx hashicorp/tap/terraform
colima start                          # free Docker engine (no Docker Desktop needed)

# Python-based tools via pipx. On macOS, keep pipx OUT of the default
# "~/Library/Application Support/pipx" path — the space breaks script shebangs:
export PIPX_HOME="$HOME/.local/pipx" PIPX_BIN_DIR="$HOME/.local/bin"
pipx install checkov awscli-local prowler scoutsuite
```
```bash
# verify your toolchain
bash tools/check-prereqs.sh
```

**Module 1 — vulnerable AWS, locally:**
```bash
cd modules/01-localstack-aws
./up.sh          # starts LocalStack + terraform apply (emulated AWS, free)
cat challenges.md   # hunt the misconfigurations with `awslocal ...`
./down.sh        # tears everything down
```

**Module 2 — scan insecure IaC (fastest win, no runtime needed):**
```bash
cd modules/02-iac-security
./scan.sh        # runs Checkov (+ tfsec/Trivy if installed) against vulnerable/
```

## Learning path

A free-first roadmap toward the career: **[docs/learning-path.md](docs/learning-path.md)**.
Short version:
1. **flaws.cloud** + **flaws2.cloud** (concepts, free, hosted).
2. **Module 1** LocalStack + **Module 2** IaC scanning (this repo, free, local).
3. **Module 3** Kubernetes Goat (containers, free, local).
4. **Module 4** Prowler/ScoutSuite; then a **real free-tier account with budget alarms** for
   CloudGoat / IAM-Vulnerable.
5. Anchor with a cert: **AWS Security – Specialty**.

## Repository layout

```
cloud-security-lab/
├── modules/
│   ├── 01-localstack-aws/     # docker-compose + Terraform (misconfigured AWS) + challenges
│   ├── 02-iac-security/       # insecure Terraform + Checkov/tfsec/Trivy scans + findings
│   ├── 03-kubernetes-goat/    # minikube + Kubernetes Goat deploy/teardown + challenges
│   └── 04-cspm-prowler/       # Prowler / ScoutSuite runners + findings template
├── docs/                      # learning-path, cost-safety, architecture, flaws.cloud
├── tools/check-prereqs.sh     # verify your toolchain + install hints
├── LICENSE                    # MIT + educational-use notice
└── .gitignore                 # excludes tf state, creds, scanner output
```

## Tech

`Terraform` · `LocalStack` · `AWS CLI` · `Checkov` · `tfsec` · `Trivy` · `Kubernetes` ·
`minikube` · `Prowler` · `ScoutSuite` · `Docker`

## License

[MIT](LICENSE), educational use only. Default path is free and local.
