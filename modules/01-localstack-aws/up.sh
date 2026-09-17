#!/usr/bin/env bash
# Start LocalStack and deploy the (intentionally insecure) Terraform. Free & local.
set -euo pipefail
cd "$(dirname "$0")"

echo "[up] starting LocalStack (Docker)..."
docker compose up -d

echo "[up] waiting for LocalStack S3 to be ready..."
for _ in $(seq 1 30); do
  if curl -sf http://localhost:4566/_localstack/health 2>/dev/null | grep -q '"s3"'; then
    break
  fi
  sleep 2
done

echo "[up] terraform init + apply (targets LocalStack, nothing billable)..."
cd terraform
terraform init -input=false
terraform apply -auto-approve

echo
echo "[up] Done. Now hunt the misconfigurations — see ../challenges.md"
echo "[up] Tip: install 'awslocal' (pipx install awscli-local) and try:"
echo "        awslocal s3 ls"
