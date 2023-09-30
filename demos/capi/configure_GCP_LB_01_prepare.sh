#!/bin/bash
## 

DIR=$(dirname "$0")

clear

pushd $DIR



echo "🏗️ - GCP Prepare configuration for Network LB to Traefik Ingress Controller"

# $CLUSTER_NAME-node
set -ex

gcloud compute instance-groups unmanaged create $CLUSTER_NAME-workers-node-europe-west1-b \
  --zone europe-west1-b


gcloud compute instance-groups set-named-ports $CLUSTER_NAME-workers-node-europe-west1-b \
  --named-ports=http:31080,https:31443 \
  --zone europe-west1-b

gcloud compute --project=$GCP_PROJECT  firewall-rules create allow-$CLUSTER_NAME-control-plane-lb \
    --direction=INGRESS --priority=1000 --network=$GCP_NETWORK_NAME --action=ALLOW --rules=tcp:31443,tcp:31080 \
    --source-ranges=35.191.0.0/16,130.211.0.0/22 --target-tags=$CLUSTER_NAME-node

gcloud compute health-checks create tcp $CLUSTER_NAME-lb-health-check --port 31080

# HTTPS 443
gcloud compute backend-services create $CLUSTER_NAME-https-lb-backend-service \
    --protocol TCP \
    --health-checks $CLUSTER_NAME-lb-health-check \
    --port-name https \
    --global

gcloud compute backend-services add-backend $CLUSTER_NAME-https-lb-backend-service \
    --instance-group $CLUSTER_NAME-workers-node-europe-west1-b \
    --instance-group-zone europe-west1-b \
    --balancing-mode UTILIZATION --max-utilization 0.8 \
    --global

gcloud compute addresses create $CLUSTER_NAME-https-lb-static-ipv4 \
    --ip-version=IPV4 \
    --global

gcloud compute target-tcp-proxies create $CLUSTER_NAME-https-lb-tcp-proxy \
    --backend-service $CLUSTER_NAME-https-lb-backend-service \
    --global

sleep 1
gcloud compute forwarding-rules create $CLUSTER_NAME-https-lb-forwarding-rule \
    --ports=443 \
    --target-tcp-proxy $CLUSTER_NAME-https-lb-tcp-proxy \
    --address $CLUSTER_NAME-https-lb-static-ipv4 \
    --global

# HTTP 80
gcloud compute backend-services create $CLUSTER_NAME-http-lb-backend-service \
    --protocol TCP \
    --health-checks $CLUSTER_NAME-lb-health-check \
    --port-name http \
    --global

gcloud compute backend-services add-backend $CLUSTER_NAME-http-lb-backend-service \
    --instance-group $CLUSTER_NAME-workers-node-europe-west1-b \
    --instance-group-zone europe-west1-b \
    --balancing-mode UTILIZATION --max-utilization 0.8 \
    --global

gcloud compute addresses create $CLUSTER_NAME-http-lb-static-ipv4 \
    --ip-version=IPV4 \
    --global

gcloud compute target-tcp-proxies create $CLUSTER_NAME-http-lb-tcp-proxy \
    --backend-service $CLUSTER_NAME-http-lb-backend-service \
    --global

sleep 1
gcloud compute forwarding-rules create $CLUSTER_NAME-http-lb-forwarding-rule \
    --ports=80 \
    --target-tcp-proxy $CLUSTER_NAME-http-lb-tcp-proxy \
    --address $CLUSTER_NAME-http-lb-static-ipv4 \
    --global

export LB_HTTPS_IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
export LB_HTTP_IP=$(gcloud compute addresses describe $CLUSTER_NAME-http-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)

echo "ADRESSE IP LB HTTPS $LB_HTTPS_IP"
echo "ADRESSE IP LB HTTP $LB_HTTP_IP"

popd
