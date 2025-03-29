output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "cognito_user_pool_arn" {
  value = aws_cognito_user_pool.this.arn
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.this.id
}

output "cognito_user_pool_client_secret" {
  value = aws_cognito_user_pool_client.this.client_secret
}

output "cognito_user_pool_domain" {
  value = format("https://%s.auth.ap-northeast-1.amazoncognito.com", aws_cognito_user_pool_domain.this.domain)
}