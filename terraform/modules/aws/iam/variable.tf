variable "blogging_events_table_arn" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "images_bucket_arn" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "blogging_events_table_stream_arn" {
  type      = string
  nullable  = false
  sensitive = true
}