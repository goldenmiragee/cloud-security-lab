#!/usr/bin/env bash
# Tear down the module: destroy Terraform resources and stop LocalStack.
set -uo pipefail
cd "$(dirname "$0")"

if docker compose version >/dev/null 2>&1; then DC="docker compose"; else DC="docker-compose"; fi

echo "[down] terraform destroy..."
( cd terraform && terraform destroy -auto-approve ) || true

echo "[down] stopping LocalStack..."
$DC down -v || true

echo "[down] done."
