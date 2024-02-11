terraform {
  required_providers {
    cockroach = {
      source  = "cockroachdb/cockroach"
      version = "1.3.1"
    }
  }
}

variable "cluster_name" {
  type     = string
  nullable = false
  default = "smiley-russ-cox"
}

variable "sql_user_name" {
  type     = string
  nullable = false
  default  = "maxroach"
}

variable "sql_user_password" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "serverless_spend_limit" {
  type     = number
  nullable = false
  default  = 1
}

variable "cloud_provider" {
  type     = string
  nullable = false
  default  = "AWS"
}

provider "cockroach" {
  # export COCKROACH_API_KEY with the cockroach cloud API Key
}

resource "cockroach_cluster" "cockroach" {
  name           = var.cluster_name
  cloud_provider = "AWS"
  serverless     = {
    usage_limits = {
      request_unit_limit = 50000000
      storage_mib_limit  = 81920
    }
  }
  regions = [{
    name = "ap-southeast-1"
  }]
}

resource "cockroach_sql_user" "cockroach" {
  cluster_id = cockroach_cluster.cockroach.id
  name       = var.sql_user_name
  password   = var.sql_user_password
}

resource "cockroach_database" "article" {
  cluster_id = cockroach_cluster.cockroach.id
  name       = "article"
}

resource "cockroach_database" "tag" {
  cluster_id = cockroach_cluster.cockroach.id
  name       = "tag"
}

output "sql_dns" {
  value = cockroach_cluster.cockroach.regions[0].sql_dns
}
