# Module 3 — Challenges (Kubernetes Goat)

[Kubernetes Goat](https://github.com/madhuakula/kubernetes-goat) is an intentionally
vulnerable cluster. Deploy it locally with `./setup.sh`, open <http://127.0.0.1:1234>, and work
the built-in scenarios. All local, all free.

## Scenario areas to complete (defend as you go)

| Scenario | You learn | Defensive fix |
|----------|-----------|---------------|
| Sensitive keys in code history | Secrets leak via git/images | Secret scanning, never bake secrets into images |
| DIND (Docker-in-Docker) exploitation | Mounting the host Docker socket = host takeover | Don't mount `docker.sock`; restrict privileged pods |
| SSRF in the cluster | Reaching internal services / metadata | Network policies, egress controls |
| Container escape to the node | Privileged containers, hostPath mounts | `securityContext`, drop capabilities, PSA/OPA |
| Docker CIS benchmarks | Baseline hardening | `docker-bench`, Trivy image scans |
| Hidden in layers | Secrets in image layers | `trivy image`, minimal base images |
| RBAC least privilege | Over-broad ServiceAccount rights | Scope Roles/RoleBindings; audit with `kubectl auth can-i` |
| Hacker container / KubeAudit | Post-exploitation in-cluster | Admission control, runtime security |

## Useful commands
```bash
kubectl get pods -A
kubectl auth can-i --list                    # what can this context do?
kubectl get roles,rolebindings -A
trivy image <image>                           # scan an image for CVEs/secrets
```

## Deliverable
For 3–4 scenarios, write: the attack, the root-cause misconfig, and the Kubernetes control that
prevents it (securityContext, NetworkPolicy, RBAC, Pod Security Admission). That mapping is the
cloud-security-engineer skill.
