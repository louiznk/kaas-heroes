#!/bin/bash
## 

clear

. demo-magic.sh

DIR=$(dirname "$0")

pushd $DIR
prompt "Get kubeconfig for $CLUSTER_NAME cluster"
echo "wait until 'kubeconfig' is ready"
set +e
RET=99
while [ "$RET" != "0" ]
do
  clusterctl get kubeconfig $CLUSTER_NAME &>/dev/null
  RET=$?
  sleep 1
  printf "."
done
echo "'kubeconfig' is ready"

set -e

pe 'clusterctl get kubeconfig $CLUSTER_NAME > $CLUSTER_KUBECONFIG'

#prompt "Import this config in .kube/config"
#pe 'kubectl konfig import --save $CLUSTER_KUBECONFIG'

popd
