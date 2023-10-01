---
apiVersion: v1
kind: Service
metadata:
  namespace: kube-system
  name: traefik-ingress-controller
spec:
  ports:
    - name: web
      port: 80
      protocol: TCP
      nodePort: $HTTP_PORT
    - name: websecure
      port: 443
      protocol: TCP
      nodePort: $HTTPS_PORT
  selector:
    app: traefik-ingress-controller
  type: NodePort
