resource "kubernetes_secret" "secret_article_service" {
  metadata {
    name = "secret-article-service"
  }
  data = {
    COCKROACHDB_DSN           = var.cockroachdb_dsn_articles
    SERVICE_NAME              = var.service_name_articles
    NEW_RELIC_CONFIG_APP_NAME = var.new_relic_config_app_name_articles
    NEW_RELIC_CONFIG_LICENSE  = var.new_relic_config_license_key
    PORT                      = var.port_articles
  }
}

resource "terraform_data" "rollout_article_service" {
  triggers_replace = {
    secret_article_service = kubernetes_secret.secret_article_service.data
  }
  provisioner "local-exec" {
    command    = <<EOF
    kubectl rollout restart deployment/article-service
    EOF
    on_failure = continue
  }
}

resource "kubernetes_secret" "secret_tag_service" {
  metadata {
    name = "secret-tag-service"
  }
  data = {
    COCKROACHDB_DSN           = var.cockroachdb_dsn_tags
    SERVICE_NAME              = var.service_name_tags
    NEW_RELIC_CONFIG_APP_NAME = var.new_relic_config_app_name_tags
    NEW_RELIC_CONFIG_LICENSE  = var.new_relic_config_license_key
    PORT                      = var.port_tags
  }
}

resource "terraform_data" "rollout_tag_service" {
  triggers_replace = {
    secret_tag_service = kubernetes_secret.secret_tag_service.data
  }
  provisioner "local-exec" {
    command    = <<EOF
    kubectl rollout restart deployment/tag-service
    EOF
    on_failure = continue
  }
}

resource "kubernetes_secret" "secret_blogging_event_service" {
  metadata {
    name = "secret-blogging-event-service"
  }
  data = {
    SERVICE_NAME               = var.service_name_blogging_events
    NEW_RELIC_CONFIG_APP_NAME  = var.new_relic_config_app_name_blogging_event
    NEW_RELIC_CONFIG_LICENSE   = var.new_relic_config_license_key
    PORT                       = var.port_blogging_events
    BLOGGING_EVENTS_TABLE_NAME = var.blogging_events_table_name
    CDN_HOST                   = var.cdn_host
    S3_BUCKET                  = var.s3_bucket_for_images
  }
}

resource "kubernetes_secret" "secret_federator" {
  metadata {
    name = "secret-federator"
  }
  data = {
    NEW_RELIC_CONFIG_APP_NAME      = var.new_relic_config_app_name_federator
    NEW_RELIC_CONFIG_LICENSE       = var.new_relic_config_license_key
    ARTICLE_SERVICE_ADDRESS        = format("article-service:%d", var.port_articles)
    TAG_SERVICE_ADDRESS            = format("tag-service:%d", var.port_tags)
    BLOGGING_EVENT_SERVICE_ADDRESS = format("blogging-event-service:%d", var.port_blogging_events)
    PORT                           = var.port_federator
    COGNITO_APP_CLIENT_ID          = var.cognito_user_pool_client_id
    COGNITO_USER_POOL_ID           = var.cognito_user_pool_id
    COGNITO_DOMAIN                 = var.cognito_user_pool_domain
  }
}

resource "terraform_data" "rollout_federator" {
  triggers_replace = {
    secret_federator = kubernetes_secret.secret_federator.data
  }
  provisioner "local-exec" {
    command    = <<EOF
    kubectl rollout restart deployment/federator
    EOF
    on_failure = continue
  }
}

resource "kubernetes_secret" "secret-aws-credentials" {
  metadata {
    name = "secret-aws-credentials"
  }
  data = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
    AWS_REGION            = var.aws_region
  }
}

resource "terraform_data" "rollout_blogging_event_service" {
  triggers_replace = {
    secret_blogging_event_service = kubernetes_secret.secret_blogging_event_service.data
    secret-aws-credentials        = kubernetes_secret.secret-aws-credentials.data
  }
  provisioner "local-exec" {
    command    = <<EOF
    kubectl rollout restart deployment/blogging-event-service
    EOF
    on_failure = continue
  }
}

resource "kubernetes_secret" "secret_read_model_updater" {
  metadata {
    name = "secret-read-model-updater"
  }
  data = {
    SERVICE_NAME                     = var.service_name_read_model_updater
    NEW_RELIC_CONFIG_APP_NAME        = var.new_relic_config_app_name_articles
    NEW_RELIC_CONFIG_LICENSE         = var.new_relic_config_license_key
    NEW_RELIC_CONFIG_APP_NAME        = var.new_relic_config_app_name_read_model_updater
    ENV                              = var.environment
    BLOGGING_EVENTS_TABLE_NAME       = var.blogging_events_table_name
    BLOGGING_EVENTS_TABLE_STREAM_ARN = var.blogging_events_table_stream_arn
    COCKROACHDB_DSN_ARTICLE          = var.cockroachdb_dsn_articles
    COCKROACHDB_DSN_TAG              = var.cockroachdb_dsn_tags
    BLOG_PUBLISH_ENDPOINT            = var.blog_publish_endpoint
    GITHUB_TOKEN                     = var.github_token
    QUEUE_URL                        = var.blogging_event_sqs_url
  }
}
