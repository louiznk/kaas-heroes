#!/usr/bin/fish
set -x GCP_REGION "europe-west1"
set -x GCP_ZONE "europe-west1-b"
set -x GCP_PROJECT "ltournayre-talks"
set -x GCP_NETWORK_NAME default
set -x TENANT_NAME demo
set -x USER_NAME bob
set DIR (dirname "$0")
set REALPATH (realpath $DIR)
set -x "TENANT_KUBECONFIG" $REALPATH/$USER_NAME-$TENANT_NAME.kubeconfig
