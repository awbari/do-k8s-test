# digitalocean k8s test cluster

A fully functional managed kubernetes cluster on digital ocean. 

* Deploys basic infrastructure via [terraform](https://www.terraform.io/) and [terragrunt](https://terragrunt.gruntwork.io/).  (Providers: [digitalocean](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs), [flux](https://registry.terraform.io/providers/fluxcd/flux/latest/docs), [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs))
* Uses [flux](https://fluxcd.io/) to apply k8s manifests
* Decrypts [sops](https://github.com/getsops/sops) secrets via flux and [age](https://github.com/FiloSottile/age)
* Routes internal traffic via [nginx-ingress](https://kubernetes.github.io/ingress-nginx/)
* Sets DNS automatically via [external-dns](https://github.com/kubernetes-sigs/external-dns)
* Issues a wildcard cert via [cert-manager](https://cert-manager.io/)

## Software

... on the commandline:

* `k9s` to view info's about the cluster
* `kubectl` to view info's about the cluster
* `kustomize` to test kustomizations
* `age` to generate encryption key
* `sops` to en-/decrypt secrets
* `terraform` to deploy infratructure
* `terragrunt` to deploy infratructure
* `flux` to reconcile k8s manifests

## Install

Installation requires a few manual steps: 

* Generate Github API Token with repo access
* Generate a digitalocean api token
* Create a spaces bucket and access keys
* Generate age secrets via `age-keygen` and copy to `~/.config/sops/age/keys.txt`
* Paste everything in `infrastructure/secrets.yaml`
* Encrypt using `sops -e -i infrastructure/secrets.yaml`

### Deploy terraform

Basic infrastructure is deployed using terraform, terragrunt and sops. The age key for flux is the same as for decrypting the secrets file (you may generate another one). 

Two default namespaces are generated: 
* `ingress` for external-dns, cert-manager and nginx-ingress
* `app` for web services that are exposed via ingress

The digital ocean secret `do-api-key` will be deployed to these two namespaces. 

```sh
cd infrastructure
sops exec-env secrets.yaml 'terragrunt plan'
sops exec-env secrets.yaml 'terragrunt apply'
```

A successful apply will generate a kubeconfig in `./config-do-test-cluster.yaml`. Copy that kubeconfig to `~/.kube` and export the envvar `export KUBECONFIG=~/.kube/config-do-test-cluster.yaml`. 

Manifests in `./k8s` are applied automatically. 

## references

* [Slugs for tf vars](https://slugs.do-api.dev/)
* [Terraform + Flux Learning Video](https://www.digitalocean.com/community/tech-talks/automating-gitops-and-continuous-delivery-with-digitalocean-kubernetes)
* [DOKS Start Kits](https://github.com/digitalocean/Kubernetes-Starter-Kit-Developers)
* [DOKS Container Blueprints](https://github.com/digitalocean/container-blueprints)
* [Flux SOPS](https://fluxcd.io/flux/guides/mozilla-sops/)
* [DOKS ExternalDNS](https://www.digitalocean.com/community/tutorials/how-to-automatically-manage-dns-records-from-digitalocean-kubernetes-using-externaldns)
* [ExternalDNS Provider DigitalOcean](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/digitalocean.md)
* [DOKS LB Config](https://docs.digitalocean.com/products/kubernetes/how-to/configure-load-balancers/)