variable "project_id" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "region" {
  type     = string
  nullable = false
}

variable "zone" {
  type     = string
  nullable = false
}

variable "network" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "subnet" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "node_tag" {
  type      = string
  nullable  = false
  sensitive = true
}
variable "domain_names" {
  type    = list(string)
  default = []
}
variable "cluster_name" {
  type     = string
  nullable = false
}
