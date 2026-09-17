# Module 4 — CSPM: Prowler / ScoutSuite

Cloud Security Posture Management: scan a whole cloud account for misconfigurations against
benchmarks (CIS), then triage and remediate. The tools are **free and read-only**.

## Prerequisites
```bash
pipx install prowler scoutsuite
# and AWS credentials configured for the account you want to audit:
aws configure --profile lab
```

## Run
```bash
./run-prowler.sh lab us-east-1      # profile, region  -> HTML/JSON in ./output/
./run-scoutsuite.sh lab            # -> scoutsuite-report/*.html
```
Then summarize using [findings-template.md](findings-template.md).

## Important — cost & scope
- These tools are **read-only auditors**, but you still point them at a real account, so read
  **[../../docs/cost-safety.md](../../docs/cost-safety.md)** and use a **dedicated account with a
  budget alarm**. (Scanning itself is free; just don't leave lab resources running.)
- **LocalStack limitation:** Community LocalStack doesn't implement the full account surface
  these tools expect, so CSPM is the one module that really shines against a **real free-tier
  account** — do it after you're comfortable with Modules 1–3.

## Why this matters for the career
CSPM triage + remediation + benchmark mapping is day-to-day cloud-security-engineer work.
Producing a clean findings report (the template) is a strong portfolio artifact.
