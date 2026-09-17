# Cost & safety — don't get a surprise bill

This lab's default path is **free and local** (LocalStack + minikube). You only risk charges
if you deliberately point a module at a **real** cloud account. If/when you do, follow this.

## Golden rules
1. **Use a dedicated learning account** — never your employer's or a shared one. Enable **MFA**.
2. **Set a budget alarm _before_ deploying anything.** AWS: **Billing → Budgets** → create a
   small monthly budget (e.g. $1–$5) with email alerts at 50/80/100%. Also enable a
   **CloudWatch billing alarm**.
3. **Estimate first.** Use the provider's own **Pricing Calculator** — don't guess. Costs vary
   by region and usage.
4. **Always tear down.** `terraform destroy` (or the tool's cleanup) at the end of every
   session. Most surprise bills are forgotten running resources (NAT gateways, EIPs, RDS, load
   balancers).
5. **Prefer free tier + tiny resources.** `t2.micro`/`t3.micro`, minimal storage, no managed
   databases or NAT gateways unless a lab requires them.
6. **Never commit credentials.** Keys live in `~/.aws/credentials` or env vars, never in git.
   This repo's `.gitignore` already blocks `*.tfvars`, `.env`, `*.pem`, `credentials`.
7. **Region discipline.** Deploy in one region; stray resources hide in regions you forget.

## Watch out for these commonly-billed resources
NAT Gateway, Elastic IPs (when unattached), RDS/Aurora, load balancers (ALB/NLB), EKS control
plane, data transfer, KMS custom keys, CloudWatch at scale, provisioned DynamoDB.

## Emergency "what did I leave on?"
- AWS **Cost Explorer** → group by service to see what's accruing.
- `terraform destroy` in each module you applied.
- Check **all regions** for stray EC2/EIP/NAT.

## LocalStack = zero cost by design
Module 1 targets `http://localhost:4566` (LocalStack), not real AWS, so `apply` creates nothing
billable. The Terraform even uses fake credentials and skips account validation. You can break
things freely.
