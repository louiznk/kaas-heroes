#!/bin/bash
## 

clear

. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR


prompt "Get kubeconfig for $CLUSTER_NAME cluster"
pe 'clusterctl get kubeconfig $CLUSTER_NAME > $CLUSTER_KUBECONFIG'

#prompt "Import this config in .kube/config"
#pe 'kubectl konfig import --save $CLUSTER_KUBECONFIG'

popd
