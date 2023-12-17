generate "backend" {
  path      = "backend_generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "fra1.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "test-cluster-terraform-state"
    key                         = "terraform.tfstate"
    access_key                  = "${get_env("TF_VAR_DO_SPACES_ID")}"
    secret_key                  = "${get_env("TF_VAR_DO_SPACES_KEY")}"
  }
}

EOF
}


generate "required_providers" {
  path      = "required_providers_generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.10.1"
    }
  }
}

provider "digitalocean" {
  token = var.DO_APIKEY
}
EOF
}
