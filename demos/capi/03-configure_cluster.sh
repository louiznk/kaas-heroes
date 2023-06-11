#!/bin/bash
## 
. demo-magic.sh


set -e

DIR=$(dirname "$0")

pushd $DIR

prompt "Install CALICO CNI"
pe "kubectl --kubeconfig=$CLUSTER_KUBECONFIG apply -f ./calico"
ps1

prompt "Install traefik"
pe "kubectl --kubeconfig=$CLUSTER_KUBECONFIG apply -f ./traefik"
ps1

prompt "Next... Configure GCP LoadBalancer"

popd
