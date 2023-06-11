#!/bin/bash
## 

set -e

DIR=$(dirname "$0")

pushd $DIR

clear

set -x

echo "The host cluster need to have a PV provider, for the test using longhorn"
kubectl create ns longhorn-system
kubectl apply -f "https://raw.githubusercontent.com/longhorn/longhorn/v1.4.2/deploy/prerequisite/longhorn-nfs-installation.yaml" -n longhorn-system
sleep 30
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --version 1.4.2 \
  --set defaultSettings.defaultReplicaCount="2" \
  --set defaultSettings.orphanAutoDeletion="true" \
  --set defaultSettings.deletingConfirmationFlag="true" \


popd
