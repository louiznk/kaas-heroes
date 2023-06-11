#!/bin/bash
set -
DIR=$(dirname "$0")
pushd $DIR

while getopts 'rcph' opts
do
  case $opts in
    p) PRELOAD=1;;
  esac
done


shift $((OPTIND-1))

if [ "x$1" == "x" ]
then
  clustername="capi-management-gcp"
else
  clustername=$1
fi
# --volume "$(pwd)/registries/k3s-config/registries.yaml:/etc/rancher/k3s/registries.yaml"
echo "****************************************************************************************************"
mkdir -p "$HOME/srv/k3d/${clustername}"

echo "🏗️ Creating the cluster"
set -x
k3d cluster create "${clustername}" --port "80:80@server:0" --port "443:443@server:0" \
--servers 1 \
--k3s-arg '--disable=traefik@server:0' \
--k3s-arg  '--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1%@server:*' \
--k3s-node-label "node.kubernetes.io/role=master@server:*" \
--volume "$HOME/srv/k3d/${clustername}/default:/var/lib/rancher/k3s/storage@all" \
--image "rancher/k3s:v1.25.7-k3s1" \
--wait

export KUBECONFIG="$(k3d kubeconfig merge ${clustername})"

kubectl version
kubectl cluster-info

{ set +x; } 2> /dev/null # silently disable xtrace

## wait for coredns
echo "⏳ Waiting for CoreDNS to be ready"
kubectl wait deployment coredns -n kube-system --timeout=-1s --for condition=available
while [ "1" != $(kubectl get deployment coredns -n kube-system -o=custom-columns=READY:.status.readyReplicas --no-headers) ]
do
    printf "."
    sleep 1
done
echo " ✅"
echo "CoreDNS is Ready"

if [ "x$PRELOAD" == "x1" ]; then
  echo "⏳ Preload docker images"
  ./offline/import_k3d.sh $clustername
  echo " ✅"
fi


popd
