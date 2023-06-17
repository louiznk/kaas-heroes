export TENANT_NAME=demo
export USER_NAME=bob
DIR=`dirname "$0"`
REALPATH=`realpath $DIR`
export "TENANT_KUBECONFIG"=$REALPATH/$USER_NAME-$TENANT_NAME.kubeconfig