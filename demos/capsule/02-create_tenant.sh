#!/bin/bash
## 
. demo-magic.sh

set -e

DIR=$(dirname "$0")

pushd $DIR

clear

prompt "🏗️ - Create Tenant named '$TENANT_NAME' ..."
line
echo "Using 02-$TENANT_NAME-tenant.yaml manifest"


# change ip
cat 02-tenant.yaml.tpl | envsubst > 02-$TENANT_NAME-tenant.yaml
pe 'cat 02-$TENANT_NAME-tenant.yaml'
line

pe 'kubectl apply -f 02-$TENANT_NAME-tenant.yaml'

prompt 'Check tenants'
pei 'kubectl get tenants'

prompt "🍹 Let's create user $USER_NAME for tenant $TENANT_NAME"

pei './hack/create-user.sh $USER_NAME $TENANT_NAME'

prompt "Create namespace $TENANT_NAME-dev for $TENANT_NAME tenant with user $USER_NAME"
line

pei 'kubectl create ns ${TENANT_NAME}-dev --kubeconfig ${USER_NAME}-${TENANT_NAME}.kubeconfig'

popd
