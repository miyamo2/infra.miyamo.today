variable "project_id" {
  type      = string
  sensitive = true
}

variable "zone" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_count" {
  type    = number
  default = 2
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}
