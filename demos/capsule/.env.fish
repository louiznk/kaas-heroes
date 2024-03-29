#!/usr/bin/fish
set -x TENANT_NAME demo
set -x USER_NAME bob
set DIR (dirname "$0")
set REALPATH (realpath $DIR)
set -x TENANT_KUBECONFIG $REALPATH/$USER_NAME-$TENANT_NAME.kubeconfig
set -x KUBECONFIG_HOST_CLUSTER "$REALPATH/../capi/base.kubeconfig"
set -x KUBECONFIG $KUBECONFIG_HOST_CLUSTER