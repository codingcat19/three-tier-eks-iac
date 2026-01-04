#!/bin/bash
set -e 

# 0. Cleanup any old "ghost" port-forwards
pkill -f "port-forward" || true

echo "🚀 Starting Kind Cluster nodes..."
docker start three-tier-cluster-control-plane three-tier-cluster-worker three-tier-cluster-worker2

echo "⏳ Waiting for Kubernetes Control Plane..."
until kubectl get nodes &> /dev/null; do
  echo "Waiting for API Server..."
  sleep 2
done

echo "🔧 Ensuring Workshop Namespace & Secrets exist..."
kubectl create namespace workshop --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic mongo-sec \
  --from-literal=username=admin \
  --from-literal=password=password123 \
  -n workshop --dry-run=client -o yaml | kubectl apply -f -

echo "⚙️  Refreshing Frontend ConfigMap..."
# Ensure you are in the directory where env-config.js lives
kubectl create configmap frontend-config --from-file=env-config.js -n workshop --dry-run=client -o yaml | kubectl apply -f -

echo "📂 Refreshing ArgoCD Application..."
kubectl apply -f /home/ubuntu/three-tier-eks-iac/argocd-app.yml

# --- CRITICAL FIX FOR RESTART MESS ---
echo "♻️  Hard resetting Pods to fix networking (SandboxChanged)..."
# We delete them so Kubernetes recreates them fresh on the 'new' nodes
kubectl delete pods -n workshop -l role=api --ignore-not-found
kubectl delete pods -n workshop -l role=web --ignore-not-found

echo "⏳ Waiting for fresh Pods to initialize (20s)..."
sleep 20
# ------------------------------------------

echo "🌐 Restarting Port-Forwarding tunnels..."
# Forwarding Frontend (3000), API (8080), and ArgoCD (8081)
kubectl port-forward --address 0.0.0.0 svc/my-three-tier-app-frontend -n workshop 3000:3000 > /dev/null 2>&1 &
kubectl port-forward --address 0.0.0.0 svc/my-three-tier-app-api -n workshop 8080:8080 > /dev/null 2>&1 &
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8081:443 > /dev/null 2>&1 &

echo "✅ Tunnels established!"

echo "🌐 Checking API Health Status..."
# This helps you see if the 404 issue is still happening
kubectl get pods -n workshop -l role=api

echo "-------------------------------------------------------"
echo "🎉 ALL SYSTEMS GO!"
echo "📱 Frontend: http://$(curl -s ifconfig.me):3000"
echo "⚙️  API (Backend): http://$(curl -s ifconfig.me):8080/api/tasks"
echo "🐙 ArgoCD: http://$(curl -s ifconfig.me):8081"
echo "-------------------------------------------------------"
echo "⚠️ IMPORTANT: If API shows 0/1, check if code uses /health or /ok."