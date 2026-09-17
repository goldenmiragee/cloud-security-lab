# Module 1 — Remediation

How to fix each planted misconfiguration. Edit `terraform/main.tf`, re-`apply`, and re-run the
challenge checks to confirm each is closed. This is the "engineering" half — what employers pay
for.

## Fix 1 — Lock down the S3 bucket
- Set **all four** public-access-block flags to `true`.
- Delete the public `aws_s3_bucket_policy` (or scope `Principal` to specific accounts/roles).
- Add **encryption at rest** and **versioning**:
```hcl
resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "aws:kms" } }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration { status = "Enabled" }
}
```

## Fix 2 — Least-privilege IAM
Replace `Action = "*"`, `Resource = "*"` with only what the app needs, scoped to specific ARNs:
```hcl
Statement = [{
  Effect   = "Allow"
  Action   = ["s3:GetObject", "s3:PutObject"]
  Resource = "${aws_s3_bucket.data.arn}/app/*"
}]
```
Prefer **roles** over long-lived users; attach managed policies deliberately.

## Fix 3 — Restrict the security group
Never allow `0.0.0.0/0` on 22/3389. Scope to a known CIDR (VPN/office) or use SSM Session
Manager / a bastion instead:
```hcl
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8"]   # or your VPN egress /32
}
# remove the 3389 rule entirely if you don't need RDP
```

## Fix 4 — Stop hardcoding secrets
- Remove the plaintext `secret_string` from Terraform. Don't store secrets in IaC or git.
- Let the secret be created empty/rotated out-of-band, or source it from a variable marked
  `sensitive = true` (still not in VCS), and rotate it.
- **Because it was committed, treat it as compromised** — rotate it and scrub git history
  (`git filter-repo` / BFG). Scan repos with `gitleaks`/`trufflehog` in CI.

## Prove it
Re-run the C1–C5 checks from [challenges.md](challenges.md): the bucket read should be denied,
the policy gone, IAM scoped, the SG restricted, and no plaintext secret in the code. Then run
**Module 2** to confirm a scanner reports zero (or far fewer) findings.
