# score-microcks

TODO:
- Test cli in k8s
- Add manifests provisioners with k8s (operator/gitops)

```bash
score-compose init \
    --patch-templates provisioners/microcks.tpl \
    --provisioners provisioners/00-service-port-with-microcks.compose.provisioners.yaml

score-compose generate score-frontend.yaml

docker compose up --build -d --remove-orphans
```

Navigate to the Microcks UI:
```bash
echo -e "http://localhost:9090"
```

Test the endpoint registered:
```bash
curl -X POST 'http://localhost:9090/rest/Order+Service+API/0.1.0/orders' \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -d '{"customerId":"lbroudoux","productQuantities":[{"productName":"Millefeuille","quantity":1},{"productName":"Eclair Cafe","quantity":2}],"totalPrice":9.4}'
```

```bash
score-k8s init \
    --provisioners provisioners/00-service-port-with-microcks-cli.k8s.provisioners.yaml

score-k8s generate score-frontend.yaml

kubectl apply -f manifests.yaml
```

Resources:
- https://microcks.io/documentation/guides/installation/docker-compose/
- https://microcks.io/documentation/guides/installation/kubernetes-operator/
- https://github.com/microcks/api-lifecycle/tree/master/shift-left-demo


TODO for Kubernetes, let's do with Operator, more compatible with GitOps:
- https://github.com/microcks/api-lifecycle/blob/master/gitops-demo/overlays/minikube.local/microcks-apisource.yaml?
- https://microcks.io/documentation/guides/installation/kubernetes-operator/
- https://hub.microcks.io/