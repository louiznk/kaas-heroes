## pour avoir son propre traefik
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