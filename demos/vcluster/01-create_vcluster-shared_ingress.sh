#!/bin/bash
## 
. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR

clear

prompt "🏗️ - Creation vcluster named '$CLUSTER_NAME' ..."
line
echo "We shared Ingress, for details cat 01-$CLUSTER_NAME-values-share-traefik.yaml"

if [ -z "$IP" ]
then
    ## GET IP
    echo "Look for https endpoints of 'base' cluster"
    export IP=$(gcloud compute addresses describe base-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
fi
prompt "API SRV url https://vcluster-$CLUSTER_NAME.$IP.sslip.io"
# change ip
cat 01-values-share-traefik.yaml.tpl | envsubst > 01-$CLUSTER_NAME-values-share-traefik.yaml
cat 01-ingress-vcluster-api.yaml.tpl | envsubst > 01-ingress-$CLUSTER_NAME-vcluster-api.yaml

pe 'vcluster create $CLUSTER_NAME --connect=false -f 01-$CLUSTER_NAME-values-share-traefik.yaml'

prompt "🍹 Let's expose vcluster $CLUSTER_NAME using an Ingress Route from host cluster"

pe 'kubectl apply -f 01-ingress-$CLUSTER_NAME-vcluster-api.yaml -n vcluster-$CLUSTER_NAME'

prompt "Get kubeconfig for $CLUSTER_NAME vcluster"
pe 'vcluster connect $CLUSTER_NAME  -n vcluster-$CLUSTER_NAME --update-current=false --server=https://vcluster-$CLUSTER_NAME.$IP.sslip.io --kube-config $CLUSTER_NAME.kubeconfig'

prompt "Test vcluster $CLUSTER_NAME"
pe "kubectl get node --kubeconfig $CLUSTER_NAME.kubeconfig"

popd
