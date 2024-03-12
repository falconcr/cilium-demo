#!/bin/bash

check_nodes_ready() {
    nodes=$(kubectl get nodes --no-headers)

    while IFS= read -r line; do
        # Get node status
        node_status=$(echo "$line" | awk '{print $2}')
        if [ "$node_status" != "Ready" ]; then
            return 1 # At least one node isn't ready
        fi
    done <<< "$nodes"

    return 0 #  All nodes are ready
}

echo "Installing Cilium"

helm repo add cilium https://helm.cilium.io

helm upgrade --install --namespace kube-system cilium cilium/cilium --values - <<EOF
kubeProxyReplacement: strict
hostServices:
  enabled: false
externalIPs:
  enabled: true
nodePort:
  enabled: true
hostPort:
  enabled: true
image:
  pullPolicy: IfNotPresent
ipam:
  mode: kubernetes
EOF

while ! check_nodes_ready; do
    echo "Waiting for the nodes in 'Ready' status..."
    sleep 5
done
