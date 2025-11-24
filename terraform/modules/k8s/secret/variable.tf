variable "cockroachdb_dsn_articles" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cockroachdb_dsn_tags" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "blogging_events_table_name" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "service_name_articles" {
  type    = string
  default = "articles"
}

variable "service_name_tags" {
  type    = string
  default = "tags"
}

variable "service_name_blogging_events" {
  type    = string
  default = "blogging_events"
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

variable "port_articles" {
  type    = number
  default = 80
}

variable "port_tags" {
  type    = number
  default = 80
}

variable "port_blogging_events" {
  type    = number
  default = 80
}

variable "port_federator" {
  type    = number
  default = 80
}

variable "aws_access_key_id" {
  type = string

  sensitive = true
}

variable "aws_secret_access_key" {
  type = string

  sensitive = true
}

variable "aws_region" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cognito_user_pool_client_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cognito_user_pool_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cognito_user_pool_domain" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "environment" {
  type     = string
  nullable = false
}

variable "blogging_events_table_stream_arn" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "new_relic_config_app_name_read_model_updater" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "github_token" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "blog_publish_endpoint" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "service_name_read_model_updater" {
  type    = string
  default = "read_model_updater"
}

variable "blogging_event_sqs_url" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "kubernetes_namespace" {
  type      = string
  nullable  = false
}

variable "kubeconfig_context" {
  type      = string
  nullable  = false
  sensitive = true
}
