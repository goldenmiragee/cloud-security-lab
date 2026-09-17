# Architecture

The lab is a set of independent **modules**. Each is self-contained, runs locally and free, and
follows the same shape: **deploy something insecure → find the problems → remediate → prove it
with a scanner.**

```
                    ┌───────────────────────────────────────────────┐
   Your machine     │                                               │
   (macOS/Windows)  │   Module 1  LocalStack (Docker) :4566          │
        │           │      └─ Terraform → emulated AWS (S3/IAM/EC2)  │
        ├───────────┤   Module 2  Checkov / tfsec / Trivy            │
        │  free,     │      └─ static scan of insecure *.tf          │
        │  local,    │   Module 3  minikube (Docker/VM)              │
        │  $0        │      └─ Kubernetes Goat workloads             │
        │           │   Module 4  Prowler / ScoutSuite               │
        │           │      └─ posture scan → findings report         │
                    └───────────────────────────────────────────────┘
   External (free):  flaws.cloud / flaws2.cloud  (hosted AWS CTF)
```

## Why LocalStack instead of real AWS
- **Zero cost, zero risk** — nothing billable is ever created; the Terraform points the AWS
  provider at `http://localhost:4566`, uses fake credentials, and skips account/credential
  validation.
- **Fast iteration** — `apply`/`destroy` in seconds, break things freely.
- **Honest limitation** — LocalStack **Community doesn't enforce IAM**. So Module 1 teaches
  resource misconfiguration and Terraform remediation; true IAM privilege-escalation practice
  belongs on flaws.cloud (free) or a guarded real account (CloudGoat / IAM Vulnerable).

## Design conventions
- Every module has a `README`/`challenges.md` (tasks) and a remediation/`findings` note.
- Insecure code is clearly marked and isolated under each module (e.g. `vulnerable/`).
- Nothing sensitive is committed: `.gitignore` blocks tf state, `*.tfvars`, `.env`, keys.
- Scripts are POSIX `sh`/`bash`, LF line endings, and print the exact commands they run.

## Portability
Built to run where you actually work (**mac mini**, via Homebrew + Colima/Docker), and equally
on Windows/WSL. The only hard dependency for Modules 1 & 3 is a Docker daemon; Module 2 needs
just Python (Checkov) and optionally tfsec/Trivy binaries.
