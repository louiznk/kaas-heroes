#!/usr/bin/fish
set -x GCP_REGION "europe-west1"
set -x GCP_ZONE "europe-west1-b"
set -x GCP_PROJECT "ltournayre-talks"
set -x GCP_NETWORK_NAME default
set -x CLUSTER_NAME demo
set DIR (dirname "$0")
set REALPATH (realpath $DIR)
set -x "CLUSTER_KUBECONFIG" $REALPATH/$CLUSTER_NAME.kubeconfig
