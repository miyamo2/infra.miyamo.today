variable "github_token" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "application_repository_name" {
  type     = string
  nullable = false
}

variable "manifest_repository_name" {
  type     = string
  nullable = false
}

variable "gcp_project_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gcp_service_account_credentials" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gcp_region" {
  type     = string
  nullable = false
}

