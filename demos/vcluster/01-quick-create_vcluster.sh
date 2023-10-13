#!/bin/bash
## 

set -e

DIR=$(dirname "$0")

pushd $DIR

clear

echo "🏗️ - Creation vcluster named 'demo' ..."
echo "We shared Ingress for simplicity, see values-share-traefik"

if [ -z "$IP" ]
then
    ## GET IP
    export IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
fi
echo "API SRV url https://vcluster-$CLUSTER_NAME.$IP.sslip.io"
# change ip
cat 01-values-share-traefik.yaml.tpl | envsubst > 01-$CLUSTER_NAME-values-share-traefik.yaml
cat 01-ingress-vcluster-api.yaml.tpl | envsubst > 01-ingress-$CLUSTER_NAME-vcluster-api.yaml

vcluster create $CLUSTER_NAME --connect=false -f 01-$CLUSTER_NAME-values-share-traefik.yaml

echo "🍹 Let's expose vcluster kube api srv $CLUSTER_NAME with our Ingress Route"

kubectl apply -f 01-ingress-$CLUSTER_NAME-vcluster-api.yaml -n vcluster-$CLUSTER_NAME

echo "Get kubeconfig for $CLUSTER_NAME vcluster"
vcluster connect $CLUSTER_NAME  -n vcluster-$CLUSTER_NAME --update-current=false --server=https://vcluster-$CLUSTER_NAME.$IP.sslip.io --kube-config $CLUSTER_NAME.kubeconfig

echo "Test vcluster $CLUSTER_NAME"
kubectl get node --kubeconfig $CLUSTER_NAME.kubeconfig

popd
