#!/usr/bin/env bash
# Tear down the module: destroy Terraform resources and stop LocalStack.
set -uo pipefail
cd "$(dirname "$0")"

echo "[down] terraform destroy..."
( cd terraform && terraform destroy -auto-approve ) || true

echo "[down] stopping LocalStack..."
docker compose down -v || true

echo "[down] done."
