variable "environment" {
  type     = string
  nullable = false
}

variable "blogging_event_stream_arn" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "blogging_event_sqs_arn" {
  type      = string
  nullable  = false
  sensitive = true
}