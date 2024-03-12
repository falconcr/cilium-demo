#!/bin/bash

echo "Installing service map"

helm upgrade cilium cilium/cilium --version 1.14.3 \
   --namespace kube-system  \
   --reuse-values \
   --set hubble.relay.enabled=true \
   --set hubble.ui.enabled=true
