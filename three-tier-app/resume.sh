#!/bin/bash
docker start $(docker ps -a -q --filter "label=io.x-k8s.kind.cluster=kind")
sleep 20
kubectl patch deployment metrics-server -n kube-system --type 'json' -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
kubectl create configmap frontend-config --from-file=env-config.js -n workshop --dry-run=client -o yaml | kubectl apply -f -
helm upgrade my-app . -n workshop
