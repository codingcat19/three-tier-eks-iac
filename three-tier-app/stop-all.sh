#!/bin/bash
echo "Stopping the Three-Tier Application..."
helm uninstall my-app -n workshop
kubectl delete configmap frontend-config -n workshop --ignore-not-found

echo "Pausing the Kind Cluster nodes..."
docker stop three-tier-cluster-control-plane three-tier-cluster-worker three-tier-cluster-worker2

echo "Done! You can now safely stop your EC2 instance."
