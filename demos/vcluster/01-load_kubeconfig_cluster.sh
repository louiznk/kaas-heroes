#!/bin/bash
## 

. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR


prompt "Get kubeconfig for $CLUSTER_NAME vcluster"
pe 'vcluster connect $CLUSTER_NAME  -n vcluster-$CLUSTER_NAME --update-current=false --server=https://vcluster-$CLUSTER_NAME.$IP.sslip.io --kube-config $CLUSTER_NAME.kubeconfig'

#prompt "Import this config in .kube/config"
#pe 'kubectl konfig import --save $CLUSTER_KUBECONFIG'

popd