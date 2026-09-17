#!/usr/bin/env bash
# Deploy Kubernetes Goat on a local minikube cluster. Free & local.
set -euo pipefail
cd "$(dirname "$0")"

command -v minikube >/dev/null 2>&1 || { echo "Need minikube: brew install minikube"; exit 1; }
command -v kubectl  >/dev/null 2>&1 || { echo "Need kubectl: brew install kubectl";  exit 1; }
command -v git      >/dev/null 2>&1 || { echo "Need git";                             exit 1; }

echo "[k8s-goat] starting minikube (Docker driver)..."
minikube start --driver=docker

if [ ! -d kubernetes-goat ]; then
  echo "[k8s-goat] cloning Kubernetes Goat..."
  git clone https://github.com/madhuakula/kubernetes-goat.git
fi

cd kubernetes-goat
echo "[k8s-goat] deploying scenarios..."
bash setup-kubernetes-goat.sh

echo "[k8s-goat] starting port-forward access..."
bash access-kubernetes-goat.sh

cat <<'EOF'

[k8s-goat] Kubernetes Goat is up.
  - Home/instructions:  http://127.0.0.1:1234
  - Work the scenarios in ../challenges.md
  - Tear down with ./teardown.sh
EOF
