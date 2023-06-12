---
apiVersion: capsule.clastix.io/v1beta2
kind: Tenant
metadata:
  name: $TENANT_NAME
spec:
  owners:
  - name: $USER_NAME
    kind: User
  namespaceOptions:
    quota: 2
#  nodeSelector:
#    dedicatedTo: $TENANT_NAME
#    kubernetes.io/os: linux
  resourceQuotas:
    scope: Tenant
    items:
    - hard:
        limits.cpu: "4"
        limits.memory: 4Gi
        requests.cpu: "2"
        requests.memory: 2Gi
    - hard:
        pods: "10"
  limitRanges:
    items:
    - limits:
      - default:
          cpu: 500m
          memory: 512Mi
        defaultRequest:
          cpu: 100m
          memory: 10Mi
        type: Container