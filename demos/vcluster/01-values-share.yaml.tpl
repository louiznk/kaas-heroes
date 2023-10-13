## pour avoir le traefik partagée (pas par défaut)
# fait la sync entre l'objet créer dans le vcluster et l'objet dans le namespace vcluster de l'hôte
# applique certaines translations de nom et namespaces (pour les ressources utilisés...)
---
sync:
  persistentvolumes:
    enabled: true
  ## for enabled custom storage classes inside the vcluster.
  #storageclasses:
  #  enabled: true
  ## for sync node
  #nodes:
  #  enabled: true
  #  syncAllNodes: true
syncer:
  extraArgs:
  - --tls-san=vcluster-$CLUSTER_NAME.$IP.sslip.io