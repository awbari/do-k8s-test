# digitalocean k8s test cluster

## Manual steps

* Create a spaces bucket
* Create API Keys for Spaces
* Paste API Keys in `.env`

## Deploy infrastructure

```sh
cd infrastructure
terragrunt apply
```

The kubeconfig will be written to `./config-do-test-cluster.yaml`.

## Use kubeconfig

```sh
cp config-do-test-cluster.yaml ~/.kube
export KUBECONFIG=~/.kube/config-do-test-cluster.yaml
k9s # start k9s for example
```

## Deploy services

```
cd services/xy
kubectl apply -k .
```

## references

* [Slugs for tf vars](https://slugs.do-api.dev/)
* [Terraform + Flux Learning Video](https://www.digitalocean.com/community/tech-talks/automating-gitops-and-continuous-delivery-with-digitalocean-kubernetes)
* [DOKS Start Kits](https://github.com/digitalocean/Kubernetes-Starter-Kit-Developers)
* [DOKS Container Blueprints](https://github.com/digitalocean/container-blueprints)
