#!/bin/bash
## 

clear

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

set +e

DESC_LB_HTTPS_IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global)
RET=$?
if [[ "$RET" == "0" ]]
then
    HTTPS_IP=$(echo $DESC_LB_HTTPS_IP | head -n 1 | cut -d ' ' -f 2)
    prompt "Next... test traefik (GCP LB is ready) https://$LB_HTTPS_IP:443 -k"
else
    prompt "Next... check GCP LB (not ready)"
fi


popd
