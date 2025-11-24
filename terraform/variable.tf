variable "environment" {
  type    = string
  default = "dev"
}

variable "cockroach_sql_user_name" {
  type      = string
  nullable  = false
  default   = "maxroach"
  sensitive = true
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

variable "new_relic_config_app_name_read_model_updater" {
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

variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}

variable "kubeconfig_context" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gh_token" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "blog_publish_endpoint" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "kubernetes_namespace" {
  type     = string
  nullable = false
}
