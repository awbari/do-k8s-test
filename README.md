# digitalocean k8s test cluster

## TODO

* [x] Setup kubernetes through terraform
* [x] Setup flux GitOps
* [x] Add Domain
* [x] Install nginx ingress
* [ ] Add SOPS Secrets (for flux)
* [ ] Add [External DNS](https://www.digitalocean.com/community/tutorials/how-to-automatically-manage-dns-records-from-digitalocean-kubernetes-using-externaldns) for automatic DNS entries through ingress
* [ ] Add tls

## Manual steps

* Create a spaces bucket
* Create API Keys for Spaces
* Create a age secret key `age-keygen`
* Paste API Keys via sops in `infrastructure/secrets.yaml`
* Create sops age secret for flux: 
  ```
  cat path/to/key.txt | kubectl create secret generic sops-age --namespace=flux-system --from-file=age.agekey=/dev/stdin
  ```

## Deploy infrastructure

* Secret key is present in `~/.config/sops/age/keys.txt`

```sh
cd infrastructure
sops exec-env secrets.yaml 'terragrunt plan'
sops exec-env secrets.yaml 'terragrunt apply'
```

The kubeconfig will be written to `./config-do-test-cluster.yaml`.

## Use kubeconfig

```sh
cp config-do-test-cluster.yaml ~/.kube
export KUBECONFIG=~/.kube/config-do-test-cluster.yaml
k9s # start k9s for example
```

## Deploy services

Services should be deployed via flux. Flux is watching on `./k8s/kustomization.yaml`.

## references

* [Slugs for tf vars](https://slugs.do-api.dev/)
* [Terraform + Flux Learning Video](https://www.digitalocean.com/community/tech-talks/automating-gitops-and-continuous-delivery-with-digitalocean-kubernetes)
* [DOKS Start Kits](https://github.com/digitalocean/Kubernetes-Starter-Kit-Developers)
* [DOKS Container Blueprints](https://github.com/digitalocean/container-blueprints)
* [Flux SOPS](https://fluxcd.io/flux/guides/mozilla-sops/)