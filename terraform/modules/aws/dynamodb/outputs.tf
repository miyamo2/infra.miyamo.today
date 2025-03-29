output "blogging_events_table_name" {
  value = aws_dynamodb_table.this.name
}

output "blogging_events_table_arn" {
  value = aws_dynamodb_table.this.arn
}

output "blogging_events_table_stream_arn" {
  value = aws_dynamodb_table.this.stream_arn
}