#!/bin/bash
echo "Starting Kind Cluster nodes..."
docker start three-tier-cluster-control-plane three-tier-cluster-worker three-tier-cluster-worker2

echo "Waiting for nodes to be Ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s

echo "Fixing Metrics Server (for HPA scaling)..."
# Re-apply the patch in case the metrics-server pod restarted
kubectl patch deployment metrics-server -n kube-system --type 'json' -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' 2>/dev/null

echo "Creating Secret and ConfigMap..."
kubectl create namespace workshop 2>/dev/null
kubectl create secret generic mongo-sec --from-literal=username=admin --from-literal=password=password123 -n workshop 2>/dev/null
# Use 'apply' or 'delete/create' to ensure the ConfigMap is fresh
kubectl create configmap frontend-config --from-file=env-config.js -n workshop --dry-run=client -o yaml | kubectl apply -f -

echo "Deploying Application via Helm..."
cd /home/ubuntu/three-tier-eks-iac/three-tier-app
# 'upgrade --install' is safer than just 'install'
helm upgrade --install my-app . -n workshop

echo "Everything is coming back online!"
echo "Check pods with: kubectl get pods -n workshop -w"