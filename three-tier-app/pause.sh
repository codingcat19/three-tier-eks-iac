#!/bin/bash
echo "🧹 Clearing local port-forwarding processes..."
pkill -f "port-forward" || true

echo "💾 Preserving ArgoCD state (Not deleting app)..."
# We DO NOT delete the application here. 
# We want the DB and PVCs to stay defined so they exist when we wake up.

echo "⏸️  Pausing Kind Cluster containers..."
docker stop three-tier-cluster-control-plane three-tier-cluster-worker three-tier-cluster-worker2

echo "✨ System paused. Data is safe in the Docker volumes."