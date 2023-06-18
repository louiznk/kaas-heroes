#!/bin/bash
export GCP_REGION="europe-west1"
export GCP_ZONE="europe-west1-b"
export GCP_PROJECT="ltournayre-talks"
export GCP_NETWORK_NAME=default
export CLUSTER_NAME=base
DIR=`dirname "$0"`
REALPATH=`realpath $DIR`
export "CLUSTER_KUBECONFIG"=$REALPATH/$CLUSTER_NAME.kubeconfig
export WORKER_NB=3
export CONTROL_PLANE_NB=1
export GCP_CONTROL_PLANE_MACHINE_TYPE=n2d-standard-2
export GCP_NODE_MACHINE_TYPE=n2d-standard-4
