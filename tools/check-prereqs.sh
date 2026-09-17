#!/usr/bin/env bash
# Check the lab toolchain and print install hints (macOS Homebrew / pipx).
# Nothing is required to be present to run this — it just reports.
set -uo pipefail

check() {
  local name="$1" hint="$2" ver
  if ! command -v "$name" >/dev/null 2>&1; then
    printf '  [MISS] %-11s -> %s\n' "$name" "$hint"
    return
  fi
  # try common version invocations; if none run, the tool is installed but broken
  if ver="$("$name" --version 2>/dev/null)" || ver="$("$name" version 2>/dev/null)"; then
    printf '  [ok]   %-11s %s\n' "$name" "$(printf '%s' "$ver" | head -n1)"
  else
    printf '  [WARN] %-11s installed but failed to run (e.g. broken pipx shebang)\n' "$name"
  fi
}

echo "== Core =="
check docker    "brew install --cask docker   (or: brew install colima && colima start)"
check terraform "brew install terraform"
check aws       "brew install awscli"
check awslocal  "pipx install awscli-local"

echo "== Scanners (Module 2) =="
check checkov   "pipx install checkov"
check tfsec     "brew install tfsec"
check trivy     "brew install trivy"

echo "== Kubernetes (Module 3) =="
check kubectl   "brew install kubectl"
check minikube  "brew install minikube"

echo "== CSPM (Module 4) =="
check prowler   "pipx install prowler"
check scout     "pipx install scoutsuite"

cat <<'EOF'

Per-module minimums:
  Module 1 (LocalStack AWS) : docker, terraform, awslocal
  Module 2 (IaC scanning)   : checkov            (tfsec/trivy optional)
  Module 3 (Kubernetes Goat): minikube, kubectl  (docker/colima)
  Module 4 (CSPM)           : prowler or scout   + a configured AWS profile
EOF
