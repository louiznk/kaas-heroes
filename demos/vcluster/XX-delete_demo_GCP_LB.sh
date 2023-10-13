#!/bin/bash

set -x

#vcluster delete $CLUSTER_NAME

{ set +x; } 2> /dev/null # silently disable xtrace
echo "Delete GCP Network config for cluster $CLUSTER_NAME"
set -x
gcloud compute forwarding-rules delete $CLUSTER_NAME-https-lb-forwarding-rule --global -q
gcloud compute forwarding-rules delete $CLUSTER_NAME-http-lb-forwarding-rule --global -q
{ set +x; } 2> /dev/null # silently disable xtrace
sleep 1
set -x

gcloud compute addresses delete $CLUSTER_NAME-https-lb-static-ipv4 --global -q
gcloud compute addresses delete $CLUSTER_NAME-http-lb-static-ipv4 --global -q

gcloud compute target-tcp-proxies delete $CLUSTER_NAME-https-lb-tcp-proxy  --global -q
gcloud compute target-tcp-proxies delete $CLUSTER_NAME-http-lb-tcp-proxy --global -q
{ set +x; } 2> /dev/null # silently disable xtrace
sleep 1
set -x

gcloud compute backend-services delete $CLUSTER_NAME-https-lb-backend-service --global -q
gcloud compute backend-services delete $CLUSTER_NAME-http-lb-backend-service --global -q
{ set +x; } 2> /dev/null # silently disable xtrace
sleep 1
set -x

gcloud compute health-checks delete $CLUSTER_NAME-lb-health-check --global -q
gcloud compute --project=$GCP_PROJECT firewall-rules delete allow-$CLUSTER_NAME-control-plane-lb -q

{ set +x; } 2> /dev/null # silently disable xtrace