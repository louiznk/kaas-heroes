#!/bin/bash
echo "Login to argocd"

if [ -z "$IP" ]
then
    ## GET IP
    export IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
    echo "ADRESSE IP LB $IP"
fi

set -x
argocd login \
    --insecure \
    --username admin \
    --grpc-web \
    argocd.$IP.sslip.io


