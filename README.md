# score-microcks

```bash
score-compose init \
    --patch-templates provisioners/microcks.tpl \
    --provisioners provisioners/00-service-port.compose.provisioners.yaml

score-compose generate score.yaml

docker compose up --build -d --remove-orphans
```

```bash
score-k8s init \
    --provisioners provisioners/00-service-port.k8s.provisioners.yaml

score-k8s generate score.yaml

kubectl apply -f manifests.yaml
```

Resources:
- https://microcks.io/documentation/guides/installation/docker-compose/
- https://microcks.io/documentation/guides/installation/kubernetes-operator/
- https://github.com/microcks/api-lifecycle/tree/master/shift-left-demo


TODO for Kubernetes, let's do with Operator, more compatible with GitOps:
- https://github.com/microcks/api-lifecycle/blob/master/gitops-demo/overlays/minikube.local/microcks-apisource.yaml?
- https://microcks.io/documentation/guides/installation/kubernetes-operator/