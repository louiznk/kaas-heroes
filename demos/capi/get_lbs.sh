#!/bin/bash
## 

DIR=$(dirname "$0")

pushd $DIR

set -ex
LB_HTTPS_IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
LB_HTTP_IP=$(gcloud compute addresses describe $CLUSTER_NAME-http-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)

echo "ADRESSE IP LB HTTPS $LB_HTTPS_IP"
echo "ADRESSE IP LB HTTP $LB_HTTP_IP"
set +x

popd