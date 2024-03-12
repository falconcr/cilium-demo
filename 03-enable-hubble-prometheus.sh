#!/bin/bash

echo "enabling hubble"
helm upgrade cilium cilium/cilium --version 1.14.3 \
   --namespace kube-system \
   --reuse-values \
   --set prometheus.enabled=true \
   --set operator.prometheus.enabled=true \
   --set hubble.enabled=true \
   --set hubble.metrics.enableOpenMetrics=true \
   --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}"

echo "Installing prometheus"
kubectl apply -f https://raw.githubusercontent.com/falconcr/cilium-observability/main/chapter-3/monitoring.yaml
