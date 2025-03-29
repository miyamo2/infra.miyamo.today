resource "aws_dynamodb_table" "this" {
  billing_mode                = var.billing_mode
  deletion_protection_enabled = false
  hash_key                    = "event_id"
  name                        = format("blogging_events-%s", var.environment)
  range_key                   = "article_id"

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  table_class      = "STANDARD"
  tags = {
    "Environment" = var.environment
  }
  tags_all = {
    "Environment" = var.environment
  }
  write_capacity = var.write_capacity
  read_capacity  = var.read_capacity

  attribute {
    name = "article_id"
    type = "S"
  }
  attribute {
    name = "event_id"
    type = "S"
  }

  global_secondary_index {
    hash_key           = "article_id"
    name               = "article_id_event_id-Index"
    non_key_attributes = []
    projection_type    = "ALL"
    range_key          = "event_id"
    read_capacity      = var.article_id_event_id_index.read_capacity
    write_capacity     = var.article_id_event_id_index.write_capacity
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery.enabled
  }

  ttl {
    enabled = var.ttl.enabled
  }
}
