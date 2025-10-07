terraform {
  required_version = ">= 1.11.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }
    cockroach = {
      source  = "cockroachdb/cockroach"
      version = "1.11.2"
    }
  }
  backend "s3" {
    region = "ap-northeast-1"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  is_unix = substr(abspath(path.cwd), 0, 1) == "/"
}

provider "cockroach" {
  apikey = var.cockroach_api_key
}

module "cockroach" {
  source            = "./modules/cockroach"
  cluster_name      = var.cockroach_cluster_name
  region            = var.cockroach_region
  sql_user_name     = var.cockroach_sql_user_name
  sql_user_password = var.cockroach_sql_user_password
  cloud_provider    = var.cockroach_cloud_provider
  cockroach_api_key = var.cockroach_api_key
  plan              = var.cockroach_plan
}

module "network" {
  source       = "./modules/gcp/network"
  project_id   = var.gcp_project_id
  vpc_name     = "blogapi-miyamo-today-vpc"
  network_name = "blogapi-miyamo-today-network"
  subnet_name  = "blogapi-miyamo-today-subnet"
}

module "gke" {
  source       = "./modules/gcp/gke"
  project_id   = var.gcp_project_id
  zone         = var.zone
  network_name = module.network.network_name
  subnet_name  = module.network.subnet_name
  cluster_name = var.gke_cluster_name
  node_count   = var.gke_node_count
  machine_type = var.gke_machine_type
}

provider "helm" {
  kubernetes {
    config_path    = pathexpand(var.kubeconfig_path)
    config_context = module.gke.config_context
  }
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig_path)
  config_context = module.gke.config_context
}

module "k8s_ingress" {
  source     = "./modules/k8s/ingress"
  depends_on = [module.gke]
}

module "nat" {
  source       = "./modules/gcp/nat"
  project_id   = var.gcp_project_id
  region       = var.gcp_region
  zone         = var.zone
  network      = module.network.network_name
  subnet       = module.network.subnet_self_link
  node_tag     = module.gke.node_tag
  cluster_name = module.gke.cluster_name
  domain_names = var.domain_names
  depends_on   = [module.k8s_ingress]
}

module "k8s_descheduler" {
  source     = "./modules/k8s/descheduler"
  depends_on = [module.nat]
}

module "k8s_argocd" {
  source         = "./modules/k8s/argocd"
  depends_on     = [module.nat]
  config_context = module.gke.config_context
}

module "k8s_cockroachdb" {
  source         = "./modules/k8s/cockroachdb"
  config_context = module.gke.config_context
  sql_user_name  = var.cockroach_sql_user_name
}

module "dynamodb" {
  source       = "./modules/aws/dynamodb"
  billing_mode = "PROVISIONED"
  environment  = var.environment
}

module "s3" {
  source                 = "./modules/aws/s3"
  bucket_name_for_images = var.s3_bucket_for_images
}

module "aws_iam" {
  source                    = "./modules/aws/iam"
  environment               = var.environment
  blogging_events_table_arn = module.dynamodb.blogging_events_table_arn
  images_bucket_arn         = module.s3.images_bucket_arn
}

module "cognito" {
  source      = "./modules/aws/cognito"
  environment = var.environment
}

module "ssm_parameter" {
  source                           = "./modules/aws/ssm_parameter_store"
  environment                      = var.environment
  cockroachdb_dsn_articles         = module.k8s_cockroachdb.dsn_article
  cockroachdb_dsn_tags             = module.k8s_cockroachdb.dsn_tag
  blogging_events_table_name       = module.dynamodb.blogging_events_table_name
  blogging_events_table_stream_arn = module.dynamodb.blogging_events_table_stream_arn
}

module "k8s_secret" {
  source                                   = "./modules/k8s/secret"
  config_context                           = module.gke.config_context
  cdn_host                                 = var.cdn_host
  new_relic_config_app_name_articles       = var.new_relic_config_app_name_articles
  new_relic_config_app_name_blogging_event = var.new_relic_config_app_name_blogging_event
  new_relic_config_app_name_federator      = var.new_relic_config_app_name_federator
  new_relic_config_app_name_tags           = var.new_relic_config_app_name_tags
  new_relic_config_license_key             = var.new_relic_config_license_key
  s3_bucket_for_images                     = var.s3_bucket_for_images
  cockroachdb_dsn_articles                 = module.k8s_cockroachdb.dsn_article
  cockroachdb_dsn_tags                     = module.k8s_cockroachdb.dsn_tag
  blogging_events_table_name               = module.dynamodb.blogging_events_table_name
  aws_access_key_id                        = module.aws_iam.access_key
  aws_secret_access_key                    = module.aws_iam.secret_key
  aws_region                               = "ap-northeast-1"
  cognito_user_pool_id                     = module.cognito.cognito_user_pool_id
  cognito_user_pool_client_id              = module.cognito.cognito_user_pool_client_id
  cognito_user_pool_domain                 = module.cognito.cognito_user_pool_domain
}

module "gh_secret" {
  source                      = "./modules/github/secret"
  app_id                      = var.gh_app_id
  installation_id             = var.gh_installation_id
  secret                      = var.gh_secret
  application_repository_name = var.application_repository_name
  manifest_repository_name    = var.manifest_repository_name
  gcp_project_id              = var.gcp_project_id
  gcp_region                  = var.gcp_region
}
