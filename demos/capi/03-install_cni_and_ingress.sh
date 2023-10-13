#!/bin/bash
## 

clear

. demo-magic.sh


set -e

DIR=$(dirname "$0")

pushd $DIR

prompt "Install CALICO CNI"
pe 'kubectl --kubeconfig=$CLUSTER_KUBECONFIG apply -f ./calico'
ps1

prompt "Install traefik"
pe 'kubectl --kubeconfig=$CLUSTER_KUBECONFIG apply -f ./traefik'
ps1

set +e
HTTPS_IP=$(gcloud compute addresses list --filter="name=$CLUSTER_NAME-https-lb-static-ipv4" --format="csv(address)" 2>/dev/null | tail -n 1)
if [[ "$HTTPS_IP" != "" ]]
then
    prompt "Next... test traefik (GCP LB is ready) https://$HTTPS_IP:443 -k"
else
    prompt "Next... check GCP LB (will be ready soon)"
fi


popd
