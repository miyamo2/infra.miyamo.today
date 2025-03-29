variable "environment" {
  type     = string
  nullable = false
}

variable "cockroachdb_dsn_articles" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cockroachdb_dsn_tags" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "blogging_events_table_name" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "blogging_events_table_stream_arn" {
  type      = string
  nullable  = false
  sensitive = true
}