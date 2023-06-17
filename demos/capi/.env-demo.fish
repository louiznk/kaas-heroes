#!/usr/bin/fish
set -x GCP_REGION "europe-west1"
set -x GCP_ZONE "europe-west1-b"
set -x GCP_PROJECT "ltournayre-talks"
set -x GCP_NETWORK_NAME default
set -x CLUSTER_NAME demo
set DIR (dirname "$0")
set REALPATH (realpath $DIR)
set -x "CLUSTER_KUBECONFIG" $REALPATH/$CLUSTER_NAME.kubeconfig
set -x WORKER_NB 2
set -x CONTROL_PLANE_NB 1
set -x GCP_CONTROL_PLANE_MACHINE_TYPE n2d-standard-2
set -x GCP_NODE_MACHINE_TYPE n2d-standard-2
