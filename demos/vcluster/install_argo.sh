#!/bin/bash
# echo "****************************************************************************************************"
# echo "Before you need to manually install argocli"
# echo "First install argocli"
# echo "VERSION=$(curl --silent \"https://api.github.com/repos/argoproj/argo-cd/releases/latest\" | grep '\"tag_name\"' | sed -E 's/.*"([^\"]+)\".*/\1/')"
# echo "curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64"
# echo "chmod +x argocd"
# echo "sudo mv argocd /usr/local/bin/argocd"
# echo "----------------------------------------------------------------------------------------------------"

## 
set -e
DIR=$(dirname "$0")

pushd $DIR

if [[ "$1" == "" ]]
then
    echo "Ip du LB HTTPS attendu en paramêtre"
    exit 1
fi
export IP=$1
# change ip
cat argo/1-ingress.tpl | envsubst > argo/1-ingress.yml


NS_ARGO_EXIST=$(kubectl get ns -o json --kubeconfig=$CLUSTER_KUBECONFIG | jq -r '.items[] | select(.metadata.name == "argocd") | has("kind")')
if [ "true" != "$NS_ARGO_EXIST" ]
then
    kubectl create namespace argocd --kubeconfig=$CLUSTER_KUBECONFIG
fi
echo "$NS_ARGO_EXIST"

echo "🏗️ Installing Argo CD"
set -x
kubectl apply -n argocd -f argo/0-install-2.6.3.yml --kubeconfig=$CLUSTER_KUBECONFIG

# echo "🏗️ Installing Traefik CRD"
# set -x
# kubectl apply -n argocd -f 01-traefik_crd.yaml --kubeconfig=$CLUSTER_KUBECONFIG


{ set +x; } 2> /dev/null # silently disable xtrace

{ set +x; } 2> /dev/null # silently disable xtrace
echo "🕸️ Exposing Argo CD dashboard "
set -x

kubectl apply -n argocd -f argo/1-ingress.yml --kubeconfig=$CLUSTER_KUBECONFIG

{ set +x; } 2> /dev/null # silently disable xtrace
echo "🔗 https://argocd-$CLUSTER_NAME.$IP.sslip.io "

echo "🙊 Update argocd passwd (when it's up and running)"
# The initial password is set in a kubernetes secret, named argocd-secret, during ArgoCD's initial start up with the name of the pod of argocd-server
# waiting...
echo "⏳ Waiting for argocd ....."
sleep 5
# pod
while [ "0" != "$(kubectl get pod -n argocd -o json --kubeconfig=$CLUSTER_KUBECONFIG | jq -r '.items[] | select(.status.phase != "Running") | has("kind")' | wc -l)" ]; do echo -n "."; sleep 1; done
# secret
while [ "" == "$(kubectl get secret -n argocd -o json --kubeconfig=$CLUSTER_KUBECONFIG | jq -r '.items[] | select(.metadata.name == "argocd-initial-admin-secret") | has("kind")')" ]; do echo -n "."; sleep 1; done
export PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" --kubeconfig=$CLUSTER_KUBECONFIG | base64 -d)

# Wait argp realy ok 
echo ""
echo "wait for argocd api ready  https://argocd-$CLUSTER_NAME.$IP.sslip.io ....."
sleep 5
x=1
HTTP_STATUS=418
while [[ $x -le 30 && "x$HTTP_STATUS" != "x200" ]]
do
  echo -n "."
  x=$(( $x + 1 ))
  sleep 1
  HTTP_STATUS=$(curl -s -o /dev/null -I -w "%{http_code}" -k https://argocd-$CLUSTER_NAME.$IP.sslip.io)
done
echo " ✅"

set -x
argocd login \
    --insecure \
    --username admin \
    --password $PASS \
    --grpc-web \
    argocd-$CLUSTER_NAME.$IP.sslip.io

{ set +x; } 2> /dev/null # silently disable xtrace
echo "🤢 Change init password $PASS with demo password : <argodemo>, don't use a simple password this is bad !"

set -x
argocd account update-password --current-password $PASS --new-password argodemo

popd

echo "🌐 Open web browser https://argocd-$CLUSTER_NAME.$IP.sslip.io (user: admin | pwd: argodemo)"
