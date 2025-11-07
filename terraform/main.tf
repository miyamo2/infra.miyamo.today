terraform {
  required_version = ">= 1.11.0"

  required_providers {
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
  }
  backend "s3" {
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  kubeconfig_path = pathexpand(var.kubeconfig_path)
}

provider "helm" {
  kubernetes {
    config_path    = local.kubeconfig_path
    config_context = var.kubeconfig_context
  }
}

provider "kubernetes" {
  config_path    = local.kubeconfig_path
  config_context = var.kubeconfig_context
}

module "k8s_cockroachdb" {
  source               = "./modules/k8s/cockroachdb"
  sql_user_name        = var.cockroach_sql_user_name
  kubernetes_namespace = var.kubernetes_namespace
  kubeconfig_context   = var.kubeconfig_context
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

module "sqs" {
  source      = "./modules/aws/sqs"
  environment = var.environment
}

module "eventbridge" {
  source                    = "./modules/aws/eventbridge"
  environment               = var.environment
  blogging_event_sqs_arn    = module.sqs.blogging_event_sqs_arn
  blogging_event_stream_arn = module.dynamodb.blogging_events_table_stream_arn
}

module "aws_iam" {
  source                           = "./modules/aws/iam"
  environment                      = var.environment
  blogging_events_table_arn        = module.dynamodb.blogging_events_table_arn
  blogging_events_table_stream_arn = module.dynamodb.blogging_events_table_stream_arn
  images_bucket_arn                = module.s3.images_bucket_arn
  blogging_event_sqs_arn           = module.sqs.blogging_event_sqs_arn
}

module "cognito" {
  source      = "./modules/aws/cognito"
  environment = var.environment
}

module "k8s_secret" {
  source                                       = "./modules/k8s/secret"
  cdn_host                                     = var.cdn_host
  new_relic_config_app_name_articles           = var.new_relic_config_app_name_articles
  new_relic_config_app_name_blogging_event     = var.new_relic_config_app_name_blogging_event
  new_relic_config_app_name_federator          = var.new_relic_config_app_name_federator
  new_relic_config_app_name_tags               = var.new_relic_config_app_name_tags
  new_relic_config_license_key                 = var.new_relic_config_license_key
  s3_bucket_for_images                         = var.s3_bucket_for_images
  cockroachdb_dsn_articles                     = module.k8s_cockroachdb.dsn_article
  cockroachdb_dsn_tags                         = module.k8s_cockroachdb.dsn_tag
  blogging_events_table_name                   = module.dynamodb.blogging_events_table_name
  aws_access_key_id                            = module.aws_iam.access_key
  aws_secret_access_key                        = module.aws_iam.secret_key
  aws_region                                   = "ap-northeast-1"
  cognito_user_pool_id                         = module.cognito.cognito_user_pool_id
  cognito_user_pool_client_id                  = module.cognito.cognito_user_pool_client_id
  cognito_user_pool_domain                     = module.cognito.cognito_user_pool_domain
  blogging_events_table_stream_arn             = module.dynamodb.blogging_events_table_stream_arn
  environment                                  = var.environment
  github_token                                 = var.gh_token
  new_relic_config_app_name_read_model_updater = var.new_relic_config_app_name_read_model_updater
  blog_publish_endpoint                        = var.blog_publish_endpoint
  blogging_event_sqs_url                       = module.sqs.blogging_event_queue_url
  kubeconfig_context                           = var.kubeconfig_context
  kubernetes_namespace                         = var.kubernetes_namespace
}
