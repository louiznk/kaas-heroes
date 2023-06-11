# Ingress vers la api srv du vcluster
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRouteTCP
metadata:
  name: vcluster-ingress
spec:
  entryPoints:
    - websecure
  routes:
  - match: HostSNI(`vcluster-$CLUSTER_NAME.$IP.sslip.io`)
    services:
    - name: $CLUSTER_NAME
      port: 443
  tls:
    passthrough: true