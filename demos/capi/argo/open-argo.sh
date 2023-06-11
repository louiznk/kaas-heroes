#!/bin/bash

if [ -z "$IP" ]
then
    ## GET IP
    export IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
    echo "ADRESSE IP LB $IP"
fi

flatpak run org.chromium.Chromium --incognito https://argocd.$IP.sslip.io 2>/dev/null &