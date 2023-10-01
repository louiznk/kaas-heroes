#!/bin/bash
## 

. demo-magic.sh

set -e 
DIR=$(dirname "$0")

clear

pushd $DIR


prompt "Install Traefik on $CLUSTER_NAME vcluster"


cat ./traefik/04_traefik-nodeport.yaml.tpl | envsubst > ./traefik/04_traefik-nodeport.yaml

pe "kubectl --kubeconfig=$CLUSTER_KUBECONFIG apply -f ./traefik"


prompt "🏗️ - GCP Configuration for Network LB to Traefik Ingress Controller  🪄✨"
echo "Using HOST CLUSTER KUBE CONFIG : $KUBECONFIG_HOST_CLUSTER"
echo "press enter when ready to launch some magic gcloud commands"
wait

set +e


# Warning => on utilise l'instance group existante, on ajouter de nouvelles règles dessus ainsi que de nouvelles adresses

# Warning il faut ajouter les nouveaux named-port (le set est un update full)
NAMED_PORTS=$(gcloud compute instance-groups get-named-ports $CLUSTER_HOST_NAME-workers-node-europe-west1-b --zone europe-west1-b --format json | jq '.[] | "\(.name)=\(.port)"' | tr '\n' ',' | tr -d '"')

echo $NAMED_PORTS | grep http-$CLUSTER_NAME
RET=$?
if [[ $"RET" != "0" ]]
then
    # On ajoute
    set -x
    gcloud compute instance-groups set-named-ports $CLUSTER_HOST_NAME-workers-node-europe-west1-b \
    --named-ports=$NAMED_PORTS,http-$CLUSTER_NAME:$HTTP_PORT,https-$CLUSTER_NAME:$HTTPS_PORT \
    --zone europe-west1-b
else
    # rien à faire
    set -x
fi

# Warning => on reutilise un instance group => firewall doit pointé sur le bon tags !
# $CLUSTER_HOST_NAME-node
gcloud compute --project=$GCP_PROJECT  firewall-rules create allow-$CLUSTER_NAME-control-plane-lb \
    --direction=INGRESS --priority=1000 --network=$GCP_NETWORK_NAME --action=ALLOW --rules=tcp:$HTTPS_PORT,tcp:$HTTP_PORT \
    --source-ranges=35.191.0.0/16,130.211.0.0/22 --target-tags=$CLUSTER_HOST_NAME-node

gcloud compute health-checks create tcp $CLUSTER_NAME-lb-health-check --port $HTTP_PORT

# HTTPS 443
gcloud compute backend-services create $CLUSTER_NAME-https-lb-backend-service \
    --protocol TCP \
    --health-checks $CLUSTER_NAME-lb-health-check \
    --port-name https-$CLUSTER_NAME \
    --global

gcloud compute backend-services add-backend $CLUSTER_NAME-https-lb-backend-service \
    --instance-group $CLUSTER_HOST_NAME-workers-node-europe-west1-b \
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
    --port-name http-$CLUSTER_NAME \
    --global

gcloud compute backend-services add-backend $CLUSTER_NAME-http-lb-backend-service \
    --instance-group $CLUSTER_HOST_NAME-workers-node-europe-west1-b \
    --instance-group-zone europe-west1-b \
    --balancing-mode UTILIZATION --max-utilization 0.8 \
    --global

gcloud compute addresses create $CLUSTER_NAME-http-lb-static-ipv4 \
    --ip-version=IPV4 \
    --global

gcloud compute target-tcp-proxies create $CLUSTER_NAME-http-lb-tcp-proxy \
    --backend-service $CLUSTER_NAME-http-lb-backend-service \
    --global

gcloud compute forwarding-rules create $CLUSTER_NAME-http-lb-forwarding-rule \
    --ports=80 \
    --target-tcp-proxy $CLUSTER_NAME-http-lb-tcp-proxy \
    --address $CLUSTER_NAME-http-lb-static-ipv4 \
    --global



{ set +x; } 2> /dev/null # silently disable xtrace
export LB_HTTPS_IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
export LB_HTTP_IP=$(gcloud compute addresses describe $CLUSTER_NAME-http-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)

echo "ADRESSE IP LB HTTPS $LB_HTTPS_IP"
echo "ADRESSE IP LB HTTP $LB_HTTP_IP"
echo "🏁 GCP LBs are ready"


popd
