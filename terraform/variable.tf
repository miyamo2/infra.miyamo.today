variable "gcp_project_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gcp_project_number" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gcp_region" {
  type     = string
  nullable = false
}

variable "gke_cluster_name" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gke_node_count" {
  type    = number
  default = 2
}

variable "gke_machine_type" {
  type    = string
  default = "e2-small"
}

variable "zone" {
  type     = string
  nullable = false
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "cockroach_cluster_name" {
  type      = string
  nullable  = false
  default   = "dummy"
  sensitive = true
}

variable "cockroach_region" {
  type     = string
  nullable = false
}

variable "cockroach_sql_user_name" {
  type      = string
  nullable  = false
  default   = "maxroach"
  sensitive = true
}

variable "cockroach_sql_user_password" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cockroach_cloud_provider" {
  type     = string
  nullable = false
  default  = "AWS"
}

variable "cockroach_api_key" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cockroach_plan" {
  type    = string
  default = "BASIC"
}

variable "new_relic_config_app_name_articles" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "new_relic_config_app_name_tags" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "new_relic_config_app_name_blogging_event" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "new_relic_config_app_name_federator" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "new_relic_config_license_key" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cdn_host" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "s3_bucket_for_images" {
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

variable "github_token" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "domain_names" {
  type     = list(string)
  nullable = false
}

variable "kubeconfig_path" {
    type      = string
    default = "~/.kube/config"
}

variable "gh_app_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gh_installation_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gh_secret" {
  type      = string
  nullable  = false
  sensitive = true
}