#!/bin/bash
## 
. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR

clear


prompt "🏗️ - Creating management cluster with kind for demo"
pe "kind create cluster --image kindest/node:v1.25.9 --name capi-management-gcp --wait 5s"
prompt "Test the cluster"

pei "kubectl ctx kind-capi-management-gcp"
pei "kubectl version"
ps1
pei "kubectl get --raw='/readyz'"
ps1
prompt "🏗️ - Init CAPI provider for GCP"
pei "export CLUSTER_TOPOLOGY=true"
prompt "Silent GCP credential binding (GCP_B64ENCODED_CREDENTIALS)"
export GCP_B64ENCODED_CREDENTIALS=$( cat /home/louis/Dev/clusters-heros/tests/gcp/ltournayre-talks-3098ff2f29d2.json | base64 | tr -d '\n' )
line
prompt "Init the CAPI GCP Provider"
pe "clusterctl init --infrastructure gcp"

## NOTE : les images ont déjà été build

popd
