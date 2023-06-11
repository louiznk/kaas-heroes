#!/bin/bash
## 
. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR

clear

prompt "🏗️ - Preparing cluster definition v1.25.10 named 'demo' ..."
line
echo "We use a GCP project allready configurate"
echo "On this GCP project machine have to access to internet but not be expose, so we create en NAT Router for this (see gcloud compute routers ...)"
echo ""
pei 'export GCP_REGION=europe-west1'
pei 'export GCP_PROJECT=ltournayre-talks'
pei 'export KUBERNETES_VERSION=1.25.10'
pei 'export IMAGE_ID=projects/$GCP_PROJECT/global/images/cluster-api-ubuntu-2204-v1-25-10-1685208070'
pei 'export GCP_CONTROL_PLANE_MACHINE_TYPE=n2d-standard-2'
pei 'export GCP_NODE_MACHINE_TYPE=n2d-standard-2'
pei 'export GCP_NETWORK_NAME=default'
pei 'export CLUSTER_NAME=demo'
line
prompt 'Use clusterctl to generate cluster manifest'

pe 'clusterctl generate cluster $CLUSTER_NAME \
  --kubernetes-version v$KUBERNETES_VERSION \
  --control-plane-machine-count=1 \
  --worker-machine-count=2 \
  > $CLUSTER_NAME.yaml'

prompt "🍹 Let's create $CLUSTER_NAME cluster"
pe 'kubectl apply -f $CLUSTER_NAME.yaml'

echo ""
echo "For watching the state of the cluster"
echo "clusterctl describe cluster $CLUSTER_NAME"
echo "kubectl get cluster"
echo ""

echo "For watching gcp instances"
echo "gcloud compute instances list"
echo "kubectl get gcpmachine"

pei 'clusterctl describe cluster $CLUSTER_NAME'

popd
