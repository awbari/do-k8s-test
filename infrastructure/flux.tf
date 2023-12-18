
resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = "do-k8s-test"
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this]
  path = "k8s"
  components = [
    "source-controller",
    "kustomize-controller",
  ]
  kustomization_override = file("${path.module}/flux-kustomization.yaml")
}
