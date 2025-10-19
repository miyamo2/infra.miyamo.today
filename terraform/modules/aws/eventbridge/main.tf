resource "aws_pipes_pipe" "this" {
  name     = format("blogging_event_pipe-%s", var.environment)
  role_arn = aws_iam_role.this.arn
  source   = var.blogging_event_stream_arn
  target   = var.blogging_event_sqs_arn

  source_parameters {
    dynamodb_stream_parameters {
      starting_position = "TRIM_HORIZON"
      batch_size        = 1
    }
    filter_criteria {
      filter {
        pattern = jsonencode({
          eventName = ["INSERT"]
        })
      }
    }
  }
  depends_on = [aws_iam_role_policy_attachment.this]
}

resource "aws_iam_role" "this" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "PipesPermissions"
        Principal = {
          Service = "pipes.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "this" {
  name = "demo_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "dynamodbPermissions",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ],
        "Resource" : [
          var.blogging_event_stream_arn
        ]
      },
      {
        "Sid" : "sqsPermissions",
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : [
          var.blogging_event_sqs_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
