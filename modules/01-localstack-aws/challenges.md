# Module 1 — Challenges (LocalStack + Terraform)

Deploy with `./up.sh`, then work these using **`awslocal`** (the LocalStack-aware AWS CLI —
`pipx install awscli-local`). `awslocal` is just `aws --endpoint-url=http://localhost:4566`.

Try each yourself before reading [remediation.md](remediation.md).

---

## C1 — Find the public bucket and read its data
```bash
awslocal s3 ls
awslocal s3 ls s3://corp-sensitive-data-lab/ --recursive
awslocal s3 cp s3://corp-sensitive-data-lab/exports/customers.csv -   # read it
```
- [ ] Which bucket is exposed, and what sensitive file is in it?
- [ ] Read the object. Why is anonymous/public read dangerous here?

## C2 — Inspect the bucket policy & public-access settings
```bash
awslocal s3api get-bucket-policy --bucket corp-sensitive-data-lab
awslocal s3api get-public-access-block --bucket corp-sensitive-data-lab
```
- [ ] Which statement makes it world-readable? (`Principal: "*"`)
- [ ] Which four public-access-block settings are all `false`?

## C3 — Find the over-permissive IAM policy
```bash
awslocal iam list-policies --scope Local
awslocal iam get-policy-version --policy-arn <arn> --version-id v1
awslocal iam list-attached-user-policies --user-name app-service
```
- [ ] What `Action`/`Resource` does the attached policy grant? Why is `*`/`*` a red flag?

## C4 — Find the security group open to the internet
```bash
awslocal ec2 describe-security-groups --group-names app-open-sg
```
- [ ] Which ingress rules allow `0.0.0.0/0`? On which admin ports (22 / 3389)?

## C5 — Retrieve the plaintext secret
```bash
awslocal secretsmanager list-secrets
awslocal secretsmanager get-secret-value --secret-id prod/db/password
```
- [ ] The password comes back in plaintext. Where else is it exposed? (Hint: it's hardcoded in
      `terraform/main.tf` — so it's in your git history too.)

---

## Deliverable (great for your portfolio)
Write a short findings report: each issue, its risk, the CIS/best-practice it violates, and the
fix. Then apply the fixes from [remediation.md](remediation.md) and re-run the checks to prove
they're closed. Module 2 shows how to catch all of these **automatically** before deploy.
