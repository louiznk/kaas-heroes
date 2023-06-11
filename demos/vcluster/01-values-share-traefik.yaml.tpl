## pour avoir le traefik partagée (pas par défaut)
# fait la sync entre l'objet créer dans le vcluster et l'objet dans le namespace vcluster de l'hôte
# applique certaines translations de nom et namespaces (pour les ressources utilisés...)
---
sync:
  ingresses:
    enabled: true
  ingressclasses:
    enabled: true
  generic:
    role:
      extraRules:
        - apiGroups: ["traefik.containo.us"]
          resources: [ "ingressroutes", "ingressroutetcps", "ingressrouteudps", "middlewares", "middlewaretcps", "serverstransports", "tlsoptions", "tlsstores", "traefikservices" ]
          verbs: ["create", "delete", "patch", "update", "get", "list", "watch"]
    clusterRole:
      extraRules:
        - apiGroups: ["apiextensions.k8s.io"]
          resources: ["customresourcedefinitions"]
          verbs: ["get", "list", "watch"]
    config: |-
      version: v1beta1
      export:
        - apiVersion: traefik.containo.us/v1alpha1
          kind: IngressRoute
          patches:
            - op: rewriteName
              path: .spec.routes[*].services[*].name
            - op: replace
              path: .spec.routes[*].services[*].namespace
              value: vcluster-$CLUSTER_NAME
        - apiVersion: traefik.containo.us/v1alpha1
          kind: IngressRouteTCP
          patches:
            - op: rewriteName
              path: .spec.routes[*].services[*].name
            - op: replace
              path: .spec.routes[*].services[*].namespace
              value: vcluster-$CLUSTER_NAME
        - apiVersion: traefik.containo.us/v1alpha1
          kind: IngressRouteUDP
          patches:
            - op: rewriteName
              path: .spec.routes[*].services[*].name
            - op: replace
              path: .spec.routes[*].services[*].namespace
              value: vcluster-$CLUSTER_NAME
        - apiVersion: traefik.containo.us/v1alpha1
          kind: Middleware 
        - apiVersion: traefik.containo.us/v1alpha1
          kind: MiddlewareTCP
        - apiVersion: traefik.containo.us/v1alpha1
          kind: ServersTransport
        - apiVersion: traefik.containo.us/v1alpha1
          kind: TLSOption
        - apiVersion: traefik.containo.us/v1alpha1
          kind: TLSStore
        - apiVersion: traefik.containo.us/v1alpha1
          kind: TraefikService
syncer:
  extraArgs:
  - --tls-san=vcluster-$CLUSTER_NAME.$IP.sslip.io