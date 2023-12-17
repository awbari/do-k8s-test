resource "digitalocean_kubernetes_cluster" "primary" {
  name    = "test-cluster"
  region  = "fra1"
  version = "1.26.9-do.0"

  node_pool {
    name       = "test-cluster-pool"
    size       = "s-1vcpu-2gb"
    node_count = 2
  }
}

resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.primary.kube_config[0].raw_config
  filename = "${path.module}/../config-do-test-cluster.yaml"
}
