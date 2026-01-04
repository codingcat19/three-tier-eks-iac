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

# Architecture Overview
The project focuses on moving away from manual deployments toward a self-healing, observable infrastructure.
- Frontend: React.js (Nginx)
- Backend: Node.js/Express API
- Database: MongoDB (Stateful with PVC)
- Orchestration: Kubernetes (Kind)
- Deployment: GitOps via ArgoCD
- Monitoring: Prometheus & Grafana

# Key DevOps Features Implemented
1. *GitOps Workflow (ArgoCD)*
Implemented a declarative CD pipeline. Any changes pushed to the main branch are automatically detected and synced by ArgoCD, ensuring the cluster state matches the Git source of truth.

2. Data Persistence
To prevent data loss during pod restarts or cluster pauses, I implemented Persistent Volume Claims (PVCs) for MongoDB. The data is mapped to the underlying Docker volumes, ensuring the database is stateful.

3. Self-Healing & Reliability
Liveness Probes: Automatically restarts containers if the application process hangs.

Readiness Probes: Ensures traffic is only routed to the API once the MongoDB handshake is successful.

Resource Limits: Defined CPU and Memory limits to prevent "Noisy Neighbor" issues within the Kind nodes.

4. Observability Stack
Configured Prometheus to scrape cluster metrics and Grafana to visualize system health.

Tracked "Golden Signals": Latency, Traffic, Errors, and Saturation.

Monitoring of Node-level resource usage on the EC2 host.
