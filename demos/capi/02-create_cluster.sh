#!/bin/bash
## 
. demo-magic.sh



set -e

DIR=$(dirname "$0")

pushd $DIR

clear

prompt "🏗️ - Preparing cluster definition v1.25.10 named '$CLUSTER_NAME' ..."
export TYPE_SPEED=40
line
echo "We use a GCP project allready configurate"
echo "On this GCP project machine have to access to internet but not be expose, so we create en NAT Router for this (see gcloud compute routers ...)"
echo ""
pei 'export GCP_REGION=europe-west1'
pei 'export GCP_PROJECT=ltournayre-talks'
pei 'export KUBERNETES_VERSION=1.25.10'
pei 'export IMAGE_ID=projects/$GCP_PROJECT/global/images/cluster-api-ubuntu-2204-v1-25-10-1685208070'
pei "export GCP_CONTROL_PLANE_MACHINE_TYPE=$GCP_CONTROL_PLANE_MACHINE_TYPE"
pei "export GCP_NODE_MACHINE_TYPE=$GCP_NODE_MACHINE_TYPE"
pei 'export GCP_NETWORK_NAME=default'
pei "export CLUSTER_NAME=$CLUSTER_NAME"
pei "export CONTROL_PLANE_NB=$CONTROL_PLANE_NB"
pei "export WORKER_NB=$WORKER_NB"
line
prompt 'Use clusterctl to generate cluster manifest'

export TYPE_SPEED=22
pe 'clusterctl generate cluster $CLUSTER_NAME \
  --kubernetes-version v$KUBERNETES_VERSION \
  --control-plane-machine-count=$CONTROL_PLANE_NB \
  --worker-machine-count=$WORKER_NB \
  > $CLUSTER_NAME.yaml'

prompt "🍹 Let's create $CLUSTER_NAME cluster using this manifest"
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
set -e
echo ""
echo "🎉 'kubeconfig' is ready"

prompt 'Generate kubeconfig for this cluster'

pei 'clusterctl get kubeconfig $CLUSTER_NAME > $CLUSTER_KUBECONFIG'

prompt "Create GCP Load Balancers for K8S ingress in background  🪄✨ ..."

rm nohup.out -f
echo "launch configure_GCP_LB_00_all_in_one.sh in background"
nohup ./configure_GCP_LB_00_all_in_one.sh &

popd
