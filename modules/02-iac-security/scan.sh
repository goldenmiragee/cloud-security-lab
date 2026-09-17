#!/usr/bin/env bash
# Static-scan the insecure Terraform with whatever scanners are installed.
# Nothing is deployed — this is pure "shift-left" analysis of the .tf files.
set -uo pipefail
cd "$(dirname "$0")"
TARGET="vulnerable"

hr() { printf '\n========== %s ==========\n' "$1"; }

hr "Checkov"
if command -v checkov >/dev/null 2>&1; then
  checkov -d "$TARGET" --compact --quiet || true
else
  echo "checkov not installed  ->  pipx install checkov   (or: pip install checkov)"
fi

hr "tfsec"
if command -v tfsec >/dev/null 2>&1; then
  tfsec "$TARGET" || true
else
  echo "tfsec not installed    ->  brew install tfsec"
fi

hr "Trivy (config)"
if command -v trivy >/dev/null 2>&1; then
  trivy config "$TARGET" || true
else
  echo "trivy not installed    ->  brew install trivy"
fi

hr "Done"
echo "Read findings.md, then fix issues (compare with secure-example.tf) and re-scan."
