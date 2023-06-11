#!/bin/bash
## 

set -e

DIR=$(dirname "$0")

pushd $DIR

set -x

kubectl version --kubeconfig $CLUSTER_KUBECONFIG --short
kubectl get --raw='/readyz' --kubeconfig $CLUSTER_KUBECONFIG
kubectl get node --kubeconfig $CLUSTER_KUBECONFIG


popd