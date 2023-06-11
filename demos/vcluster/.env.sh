#!/bin/bash
export GCP_REGION="europe-west1"
export GCP_ZONE="europe-west1-b"
export GCP_PROJECT="ltournayre-talks"
export GCP_NETWORK_NAME=default
export CLUSTER_NAME=demo
DIR=`dirname "$0"`
REALPATH=`realpath $DIR`
export "CLUSTER_KUBECONFIG"=$REALPATH/$CLUSTER_NAME.kubeconfig