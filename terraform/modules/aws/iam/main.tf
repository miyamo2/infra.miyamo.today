resource "aws_iam_user" "this" {
  name          = format("miyamo-today-api-user-%s", var.environment)
  force_destroy = true
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"
  statement {
    resources = [
      var.blogging_events_table_arn,
      format("%s/*", var.images_bucket_arn),
    ]
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:PartiQLInsert",
      "dynamodb:PartiQLUpdate",
      "dynamodb:PartiQLDelete",
      "dynamodb:PartiQLSelect",
      "dynamodb:DescribeEndpoints",
      "dynamodb:DescribeTable",
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    ]
    effect = "Allow"
  }
}

resource "aws_iam_user_policy" "this" {
  name   = "blogging-events-policy"
  user   = aws_iam_user.this.name
  policy = data.aws_iam_policy_document.this.json
}