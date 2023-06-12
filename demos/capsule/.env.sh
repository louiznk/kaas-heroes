#!/bin/bash
export GCP_REGION="europe-west1"
export GCP_ZONE="europe-west1-b"
export GCP_PROJECT="ltournayre-talks"
export GCP_NETWORK_NAME=default
export TENANT_NAME=demo
export USER_NAME=bob
DIR=`dirname "$0"`
REALPATH=`realpath $DIR`
export "TENANT_KUBECONFIG"=$REALPATH/$USER_NAME-$TENANT_NAME.kubeconfig