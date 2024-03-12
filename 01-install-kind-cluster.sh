#!/bin/bash

read -r -d '' KIND_CONFIG <<EOF
kind: Cluster
name: cilium-kcd-lax
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
nodes:
- role: control-plane
- role: worker
EOF

echo "$KIND_CONFIG" | kind create cluster --config -

echo "Getting the cluster config yaml"
kind get kubeconfig --name="cilium-kcd-lax" > kcd-lax.yaml

export KUBECONFIG="$(pwd)/kcd-lax.yaml"
