#!/usr/bin/env bash
# Run ScoutSuite (multi-cloud posture auditing) against an AWS profile.
# FREE, read-only. Same cautions as run-prowler.sh — see ../../docs/cost-safety.md.
set -uo pipefail
cd "$(dirname "$0")"

PROFILE="${1:-default}"

if ! command -v scout >/dev/null 2>&1; then
  echo "scoutsuite not installed  ->  pipx install scoutsuite"
  exit 1
fi

echo "[scoutsuite] scanning AWS profile '$PROFILE' (read-only)..."
scout aws --profile "$PROFILE" --report-dir scoutsuite-report || true
echo "[scoutsuite] done. Open scoutsuite-report/*.html"
