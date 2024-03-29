apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: argocd-server
spec:
  entryPoints:
    - websecure
  routes:
    - kind: Rule
      match: Host(`argocd-$CLUSTER_NAME.$IP.sslip.io`)
      priority: 10
      services:
        - name: argocd-server
          namespace: argocd
          port: 80
    - kind: Rule
      match: Host(`argocd-$CLUSTER_NAME.$IP.sslip.io`) && Headers(`Content-Type`, `application/grpc`)
      priority: 11
      services:
        - name: argocd-server
          namespace: argocd
          port: 80
          scheme: h2c
  tls: {}
