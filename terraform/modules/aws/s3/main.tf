resource "aws_s3_bucket" "images" {
  bucket = var.bucket_name_for_images
  lifecycle {
    ignore_changes = [
      bucket
    ]
  }
}