# Module 2 — IaC static analysis (Checkov / tfsec / Trivy)

Catch cloud misconfigurations **before** they deploy by scanning the Terraform itself. This
"shift-left" skill is core to cloud-security engineering and is completely free and offline —
no cloud account, no `apply`.

## Prerequisites (any one is enough to start)
```bash
pipx install checkov          # or: pip install checkov   (pure Python)
brew install tfsec trivy      # optional extra scanners
```

## Run
```bash
./scan.sh
# or directly:
checkov -d vulnerable
```

## What's here
- `vulnerable/main.tf` — deliberately-insecure Terraform (public S3, open SG, unencrypted
  EBS/EC2/RDS, public RDS with a hardcoded password, wildcard IAM).
- `secure-example.tf` — the hardened "after" to compare against.
- `findings.md` — the **verified** results (Checkov reported **43 failed / 13 passed** here)
  mapped to each misconfiguration, plus a CI example.

## The exercise
1. `./scan.sh` and read the findings.
2. Fix `vulnerable/main.tf` (use `secure-example.tf` as reference).
3. Re-scan and watch the failure count drop — that before/after delta is great portfolio
   evidence.
4. Wire the scanner into CI so insecure IaC can never merge (see `findings.md`).
