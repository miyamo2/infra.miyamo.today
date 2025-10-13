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

variable "gcp_region" {
  type     = string
  nullable = false
}

variable "app_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "installation_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "secret" {
  type      = string
  nullable  = false
  sensitive = true
}