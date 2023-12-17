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
