# Module 1 — LocalStack + Terraform (vulnerable AWS)

Stand up an **emulated AWS** locally with [LocalStack](https://localstack.cloud) and deploy
intentionally-misconfigured infrastructure with Terraform. Find the issues, then fix them.
**100% free — nothing billable is created.**

## Prerequisites
- Docker (Docker Desktop or Colima on macOS)
- Terraform ≥ 1.3
- `awslocal` — `pipx install awscli-local`

## Run
```bash
./up.sh          # start LocalStack + terraform apply
cat challenges.md
# ... work the challenges with awslocal ...
./down.sh        # destroy + stop LocalStack
```

## What's inside (planted misconfigurations)
1. **Public S3 bucket**, no encryption, holding sample PII.
2. **Over-permissive IAM** policy (`Action:*`, `Resource:*`) attached to a user.
3. **Security group** open to `0.0.0.0/0` on SSH (22) and RDP (3389).
4. **Plaintext secret** in Secrets Manager, hardcoded in the Terraform.

Work through [challenges.md](challenges.md), then [remediation.md](remediation.md).

## Note on LocalStack IAM
LocalStack Community **emulates** the IAM API but does not **enforce** policies. So this module
teaches spotting and fixing misconfigurations in resources and IaC. For IAM privilege-escalation
you can actually *exploit*, use [flaws.cloud](../../docs/flaws-cloud.md) (free) or a guarded real
account (CloudGoat / IAM Vulnerable) — see [cost-safety](../../docs/cost-safety.md).
