#!/bin/bash
## 

DIR=$(dirname "$0")

clear

pushd $DIR



echo "🏗️ - GCP add nodes for Network LB to Traefik Ingress Controller"

# $CLUSTER_NAME-node
set -e

echo "Sleep until 3 workers nodes are ready"
while [ "3" != "$(kubectl get node -l '!node-role.kubernetes.io/control-plane' --kubeconfig  $CLUSTER_NAME.kubeconfig --output=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | wc -l)" ]
do
    printf "."
    sleep 1
done

set -ex
gcloud compute instance-groups unmanaged add-instances $CLUSTER_NAME-workers-node-europe-west1-b \
  --instances $(kubectl get node --kubeconfig  $CLUSTER_NAME.kubeconfig -l '!node-role.kubernetes.io/control-plane' \
    --output=jsonpath='{range .items[*]}{.metadata.name},{end}') \
  --zone europe-west1-b



export LB_HTTPS_IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
export LB_HTTP_IP=$(gcloud compute addresses describe $CLUSTER_NAME-http-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)

echo "ADRESSE IP LB HTTPS $LB_HTTPS_IP"
echo "ADRESSE IP LB HTTP $LB_HTTP_IP"

popd
