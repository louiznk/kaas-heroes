#!/bin/bash

set -x

gcloud compute forwarding-rules delete $CLUSTER_NAME-https-lb-forwarding-rule --global -q
sleep 1
gcloud compute addresses delete $CLUSTER_NAME-https-lb-static-ipv4 --global -q
sleep 1
gcloud compute target-tcp-proxies delete $CLUSTER_NAME-https-lb-tcp-proxy  --global -q
sleep 1
gcloud compute backend-services delete $CLUSTER_NAME-https-lb-backend-service --global -q

gcloud compute forwarding-rules delete $CLUSTER_NAME-http-lb-forwarding-rule --global -q
sleep 1
gcloud compute addresses delete $CLUSTER_NAME-http-lb-static-ipv4 --global -q
sleep 1
gcloud compute target-tcp-proxies delete $CLUSTER_NAME-http-lb-tcp-proxy --global -q
sleep 1
gcloud compute backend-services delete $CLUSTER_NAME-http-lb-backend-service --global -q
sleep 1

gcloud compute health-checks delete $CLUSTER_NAME-lb-health-check --global -q
gcloud compute --project=$GCP_PROJECT firewall-rules delete allow-$CLUSTER_NAME-control-plane-lb -q
gcloud compute instance-groups unmanaged delete $CLUSTER_NAME-workers-node-europe-west1-b -q

kubectl delete cluster $CLUSTER_NAME