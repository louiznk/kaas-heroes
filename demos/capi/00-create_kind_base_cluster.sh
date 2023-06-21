#!/bin/bash
## 
. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR

clear

export clustername=capi-management-gcp

prompt "🏗️ - Creating management cluster with kind for demo"
pe "kind create cluster --image kindest/node:v1.25.9 --name $clustername --wait 5s"
echo "beep beep... preloading image"
./offline/import_kind.sh $clustername
prompt "Test the cluster"

pei "kubectl ctx kind-$clustername"
pei "kubectl version"
ps1
pei "kubectl get --raw='/readyz'"
ps1

popd
