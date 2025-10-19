resource "aws_sqs_queue" "blogging_event" {
  name                       = format("blogging_event_queue-%s", var.environment)
  visibility_timeout_seconds = 60
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.blogging_event_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "blogging_event_deadletter" {
  name = format("blogging_event_deadletter_queue-%s", var.environment)
}

resource "aws_sqs_queue_redrive_allow_policy" "this" {
  queue_url = aws_sqs_queue.blogging_event_deadletter.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.blogging_event.arn]
  })
}