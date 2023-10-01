#!/usr/bin/fish
set -x GCP_REGION "europe-west1"
set -x GCP_ZONE "europe-west1-b"
set -x GCP_PROJECT "ltournayre-talks"
set -x GCP_NETWORK_NAME default
set -x CLUSTER_NAME demo2
set DIR (dirname "$0")
set REALPATH (realpath $DIR)
set -x "CLUSTER_KUBECONFIG" $REALPATH/$CLUSTER_NAME.kubeconfig
set -x KUBECONFIG_HOST_CLUSTER "$REALPATH/../capi/base.kubeconfig"
set -x CLUSTER_HOST_NAME base
set -x HTTP_PORT 32080
set -x HTTPS_PORT 32443