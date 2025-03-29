resource "aws_ssm_parameter" "cockroachdb_dsn_article" {
  name  = format("/miyamo-today/cicd/%s/cockroachdb/dsn/article", var.environment)
  type  = "String"
  value = var.cockroachdb_dsn_articles
}

resource "aws_ssm_parameter" "cockroachdb_dsn_tag" {
  name  = format("/miyamo-today/cicd/%s/cockroachdb/dsn/tag", var.environment)
  type  = "String"
  value = var.cockroachdb_dsn_tags
}

resource "aws_ssm_parameter" "blogging_events_table_name" {
  name  = format("/miyamo-today/cicd/%s/dynamodb/blogging-events/name", var.environment)
  type  = "String"
  value = var.blogging_events_table_name
}

resource "aws_ssm_parameter" "blogging_events_table_stream_arn" {
  name  = format("/miyamo-today/cicd/%s/dynamodb/blogging-events/stream", var.environment)
  type  = "String"
  value = var.blogging_events_table_stream_arn
}