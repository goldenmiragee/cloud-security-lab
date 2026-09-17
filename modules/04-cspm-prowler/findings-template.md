# CSPM Findings Report — <account / date>

A short, repeatable format for turning a Prowler/ScoutSuite scan into action. Filling this out
per scan is exactly the deliverable a cloud-security engineer produces.

## Summary
- **Account / scope:** <account id / alias>
- **Tool + version:** Prowler <x> / ScoutSuite <x>
- **Scan date:** <YYYY-MM-DD>
- **Totals:** <critical> critical · <high> high · <medium> medium · <low> low

## Top findings

| # | Severity | Finding (check id) | Resource | Risk | Remediation | Status |
|---|----------|--------------------|----------|------|-------------|--------|
| 1 | Critical | e.g. S3 bucket public | `bucket-x` | Data exposure | Enable public-access block + policy review | Open |
| 2 | High | Security group 0.0.0.0/0:22 | `sg-x` | Internet-exposed SSH | Restrict CIDR / use SSM | Open |
| 3 | High | Root account without MFA | root | Account takeover | Enable MFA on root | Open |
| 4 | Medium | CloudTrail not multi-region | trail | Blind spots | Enable multi-region + log validation | Open |

## Framework mapping
Map findings to a benchmark so priorities are defensible:
- **CIS AWS Foundations Benchmark** (Prowler reports these directly)
- AWS Well-Architected — Security Pillar

## Remediation plan
1. Critical/data-exposure first (public storage, exposed admin ports, root MFA).
2. Detection gaps next (CloudTrail, Config, GuardDuty).
3. Hygiene (encryption defaults, key rotation, least privilege).
4. **Re-scan** to confirm closure and track the trend over time.
