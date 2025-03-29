terraform {
  required_version = ">= 1.11.0"

  required_providers {
    cockroach = {
      source  = "cockroachdb/cockroach"
      version = "1.11.2"
    }
  }
}

provider "cockroach" {
  apikey = var.cockroach_api_key
}

resource "cockroach_cluster" "this" {
  cloud_provider    = var.cloud_provider
  dedicated         = null
  delete_protection = false
  name              = var.cluster_name
  parent_id         = "root"
  plan              = var.plan
  regions = [
    {
      name    = var.region
      primary = true
    },
  ]
  serverless = {
    upgrade_type = "AUTOMATIC"
    usage_limits = {
      provisioned_virtual_cpus = null
      request_unit_limit       = 50000000
      storage_mib_limit        = 10000
    }
  }
}

resource "cockroach_database" "article" {
  cluster_id = cockroach_cluster.this.id
  name       = "article"
}

resource "cockroach_database" "tag" {
  cluster_id = cockroach_cluster.this.id
  name       = "tag"
}

resource "cockroach_sql_user" "this" {
  cluster_id = cockroach_cluster.this.id
  name       = var.sql_user_name
  password   = var.sql_user_password
}

data "cockroach_connection_string" "article" {
  id       = cockroach_cluster.this.id
  sql_user = var.sql_user_name
  password = var.sql_user_password
  database = cockroach_database.article.name
  os       = "LINUX"
}

data "cockroach_connection_string" "tag" {
  id       = cockroach_cluster.this.id
  sql_user = var.sql_user_name
  password = var.sql_user_password
  database = cockroach_database.tag.name
  os       = "LINUX"
}