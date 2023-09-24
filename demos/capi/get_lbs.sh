#!/bin/bash
## 

DIR=$(dirname "$0")

pushd $DIR

set -ex
LB_HTTPS_IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
LB_HTTP_IP=$(gcloud compute addresses describe $CLUSTER_NAME-http-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)

{ set +x; } 2> /dev/null # silently disable xtrace
echo "ADRESSE IP LB HTTPS $LB_HTTPS_IP => curl https://$LB_HTTPS_IP:443 -k"
echo "ADRESSE IP LB HTTP $LB_HTTP_IP => curl http://$LB_HTTP_IP"

popd