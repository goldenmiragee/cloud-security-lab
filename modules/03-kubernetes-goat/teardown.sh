#!/usr/bin/env bash
# Remove Kubernetes Goat and stop the local cluster.
set -uo pipefail
cd "$(dirname "$0")"

if [ -d kubernetes-goat ]; then
  ( cd kubernetes-goat && bash teardown-kubernetes-goat.sh ) || true
fi

echo "[k8s-goat] stopping minikube..."
minikube stop || true
echo "[k8s-goat] done. Run 'minikube delete' to remove the cluster entirely."
