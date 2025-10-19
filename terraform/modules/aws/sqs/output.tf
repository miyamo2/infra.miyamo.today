output "blogging_event_sqs_arn" {
  value     = aws_sqs_queue.blogging_event.arn
  sensitive = true
}

output "blogging_event_queue_url" {
  value     = aws_sqs_queue.blogging_event.url
  sensitive = true
}