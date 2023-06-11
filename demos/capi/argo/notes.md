L'ingress est en https

```
pour installer cela il faut avoir l'IP du lb HTTPS en env
export IP=$(gcloud compute addresses describe $CLUSTER_NAME-https-lb-static-ipv4 --global | head -n 1 | cut -d ' ' -f 2)
echo "ADRESSE IP LB $IP"
./01-install_argo.sh
./02-update_argo_pwd.sh
./03-login_to_argo.sh
```