#!/bin/bash
# echo "****************************************************************************************************"
# echo "Before you need to manually install argocli"
# echo "First install argocli"
# echo "VERSION=$(curl --silent \"https://api.github.com/repos/argoproj/argo-cd/releases/latest\" | grep '\"tag_name\"' | sed -E 's/.*"([^\"]+)\".*/\1/')"
# echo "curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64"
# echo "chmod +x argocd"
# echo "sudo mv argocd /usr/local/bin/argocd"
# echo "----------------------------------------------------------------------------------------------------"

## 
set -e
DIR=$(dirname "$0")

pushd $DIR
if [ -z "$IP" ]
then
    echo "Look for https endpoints of '${CLUSTER_NAME}' cluster"
    IP=$(gcloud compute addresses describe ${CLUSTER_NAME}-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
    echo "IP LB $IP"
fi

./install_argo.sh $IP

popd

