terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.2"
    }
  }
}

locals {
  repository_names = [
    var.application_repository_name,
    var.manifest_repository_name
  ]
}

provider "github" {
  owner = "miyamo2"
  app_auth {
    id              = var.app_id
    installation_id = var.installation_id
    pem_file        = var.secret
  }
}

resource "github_actions_secret" "gcp_project_id" {
  for_each        = toset(local.repository_names)
  repository      = each.value
  secret_name     = "GCP_PROJECT_ID"
  plaintext_value = var.gcp_project_id
}

resource "github_actions_secret" "gcp_service_account_credentials" {
  repository      = var.application_repository_name
  secret_name     = "GCP_SERVICE_ACCOUNT_CREDENTIALS"
  plaintext_value = var.gcp_service_account_credentials
}

resource "github_actions_secret" "gcp_region" {
  for_each        = toset(local.repository_names)
  repository      = each.value
  secret_name     = "GCP_REGION"
  plaintext_value = var.gcp_region
}

