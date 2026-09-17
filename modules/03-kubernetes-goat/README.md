# Module 3 — Kubernetes Goat (container & K8s security)

Attack and harden an intentionally-vulnerable Kubernetes cluster locally on **minikube** — free,
no cloud.

## Prerequisites
```bash
brew install minikube kubectl
brew install --cask docker      # or colima (free daemon):  brew install colima && colima start
brew install trivy              # image/scanning exercises
```

## Run
```bash
./setup.sh       # minikube up + clone & deploy Kubernetes Goat + port-forwards
# open http://127.0.0.1:1234 and work ../challenges.md
./teardown.sh    # remove Goat + stop minikube  (minikube delete to fully remove)
```

## Notes
- Kubernetes Goat is cloned at runtime into `kubernetes-goat/` (git-ignored; not vendored here).
- It is **intentionally vulnerable** — keep it on your local minikube only, never on a real or
  shared cluster.
- Pair with **Trivy** (`trivy image`, `trivy k8s`) to practice the scanning side.
