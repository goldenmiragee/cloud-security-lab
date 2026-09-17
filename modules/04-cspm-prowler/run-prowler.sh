#!/usr/bin/env bash
# Run Prowler (Cloud Security Posture Management) against an AWS profile.
#
# FREE tool. Scanning a REAL account is optional and deferred — read
# ../../docs/cost-safety.md first and use a dedicated account with a budget alarm.
# Prowler is read-only (security auditing), but always know what account you target.
set -uo pipefail
cd "$(dirname "$0")"

PROFILE="${1:-default}"
REGION="${2:-us-east-1}"

if ! command -v prowler >/dev/null 2>&1; then
  echo "prowler not installed  ->  pipx install prowler"
  exit 1
fi

echo "[prowler] scanning AWS profile '$PROFILE' in region '$REGION' (read-only)..."
mkdir -p output
prowler aws \
  --profile "$PROFILE" \
  --region "$REGION" \
  --output-directory output \
  --output-formats html json || true

echo "[prowler] done. Reports in ./output/ — summarize in findings-template.md."
