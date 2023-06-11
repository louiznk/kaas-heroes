#!/bin/bash
## 
. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR

clear

prompt "🏗️ - Init CAPI provider for GCP"
pei "export CLUSTER_TOPOLOGY=true"
prompt "Silent GCP credential binding (GCP_B64ENCODED_CREDENTIALS)"
export GCP_B64ENCODED_CREDENTIALS=$( cat /home/louis/Dev/clusters-heros/tests/gcp/ltournayre-talks-3098ff2f29d2.json | base64 | tr -d '\n' )
line
prompt "Init the CAPI GCP Provider"
pe "clusterctl init --infrastructure gcp"

## NOTE : les images ont déjà été build

popd
