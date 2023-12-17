terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.10.1"
    }
    flux = {
      source = "fluxcd/flux"
    }
    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.3.2"
    }
  }
}

provider "digitalocean" {
  token = var.DO_APIKEY
}

provider "github" {
  owner = "awbari"
  token = var.GH_TOKEN
}

provider "kubernetes" {
  host                    = digitalocean_kubernetes_cluster.primary.endpoint
  token                   = digitalocean_kubernetes_cluster.primary.kube_config[0].token
  cluster_ca_certificate  = base64decode(digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate)
}

provider "flux" {
  kubernetes = {
    host                   = digitalocean_kubernetes_cluster.primary.endpoint
    token                  = digitalocean_kubernetes_cluster.primary.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate)
  }
  git = {
    url = "ssh://git@github.com/awbari/do-k8s-test.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}