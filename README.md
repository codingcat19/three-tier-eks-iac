# three-tier-eks-iac

# Prerequisite 

**Install Kubectl**
```
https://kubernetes.io/docs/tasks/tools/
```

**Install Helm**
```
https://helm.sh/docs/intro/install/
```

```
helm repo update
```

Architecture Overview
The project focuses on moving away from manual deployments toward a self-healing, observable infrastructure.
- Frontend: React.js (Nginx)
- Backend: Node.js/Express API
- Database: MongoDB (Stateful with PVC)
- Orchestration: Kubernetes (Kind)
- Deployment: GitOps via ArgoCD
- Monitoring: Prometheus & Grafana
