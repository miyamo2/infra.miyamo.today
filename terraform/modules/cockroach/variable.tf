variable "cluster_name" {
  type      = string
  nullable  = false
  default   = "dummy"
  sensitive = true
}

variable "sql_user_name" {
  type      = string
  nullable  = false
  default   = "maxroach"
  sensitive = true
}

variable "sql_user_password" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cloud_provider" {
  type     = string
  nullable = false
  default  = "AWS"
}

variable "cockroach_api_key" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "region" {
  type     = string
  nullable = false
}

variable "plan" {
  type     = string
  nullable = false
}