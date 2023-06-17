#!/bin/bash
## 
. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR

clear

prompt "🏗️ - Install capsule with default options"
line
echo "For custom value see https://github.com/clastix/capsule/blob/master/charts/capsule/README.md#customize-the-installation"

pei 'helm repo add clastix https://clastix.github.io/charts'
pei 'helm install capsule clastix/capsule -n capsule-system --create-namespace'
#prompt 'Check the logs'
#pei 'kubectl logs deployment/capsule-controller-manager -c manager -n capsule-system'

prompt "Next create tenant"

popd
