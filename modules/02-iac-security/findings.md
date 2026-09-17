# Module 2 — Findings (IaC static analysis)

Run `./scan.sh` (or `checkov -d vulnerable`) against `vulnerable/main.tf`.

## Verified result

Scanned here with **Checkov 3.3.17**:

```
Passed checks: 13, Failed checks: 43, Skipped checks: 0
```

43 failures across the deliberately-insecure resources — this is the "before". After you apply
the remediations (mirroring `secure-example.tf`), the count drops sharply. That before/after
delta is exactly what you'd show in a PR or a portfolio writeup.

## Key findings mapped to the misconfigurations

| Misconfiguration (in `vulnerable/main.tf`) | Representative Checkov IDs |
|--------------------------------------------|-----------------------------|
| S3 public-read ACL                          | `CKV_AWS_20` |
| S3 missing/incomplete public-access block  | `CKV2_AWS_6`, `CKV_AWS_53`–`CKV_AWS_56` |
| S3 no encryption / no KMS                   | `CKV_AWS_19`, `CKV_AWS_145` |
| S3 no versioning / no logging               | `CKV_AWS_21`, `CKV_AWS_18` |
| Security group SSH open to 0.0.0.0/0        | `CKV_AWS_24` |
| Security group RDP open to 0.0.0.0/0        | `CKV_AWS_25` |
| EBS volume unencrypted                      | `CKV_AWS_3` |
| EC2 no IMDSv2 (SSRF risk) / EBS unencrypted | `CKV_AWS_79`, `CKV_AWS_8` |
| RDS publicly accessible                     | `CKV_AWS_17` |
| RDS unencrypted / no backups / no logging   | `CKV_AWS_16`, `CKV_AWS_133`, `CKV_AWS_129` |
| IAM policy grants full/`*` privileges       | `CKV2_AWS_40`, `CKV_AWS_63`, `CKV_AWS_286`–`290` |

(Full list of 43: run the scan. IDs may shift slightly between Checkov versions.)

## How to read & act on this
1. **Triage by severity/impact** — public data exposure and `0.0.0.0/0` admin ports first.
2. **Fix in the IaC**, not the console — edit the Terraform (see `secure-example.tf`).
3. **Re-scan** to prove the finding is closed (drives the count down).
4. **Automate** — this is the point: run the scanner in **CI** so insecure IaC never merges.

## Put it in CI (what the job actually looks like)
Example GitHub Actions step:
```yaml
- name: Checkov
  uses: bridgecrewio/checkov-action@v12
  with:
    directory: modules/02-iac-security/vulnerable
    quiet: true
    soft_fail: false     # fail the build on findings
```
`tfsec` and `trivy config` have equivalent actions — running two scanners catches more.
