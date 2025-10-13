output "images_bucket_arn" {
  value     = aws_s3_bucket.images.arn
  sensitive = true
}