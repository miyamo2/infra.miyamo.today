resource "aws_cognito_user_pool" "this" {
  name = format("blogapi-miyamo-today-user-pool-%s", var.environment)
  auto_verified_attributes = [
    "email",
  ]
  tags     = {}
  tags_all = {}
  username_attributes = [
    "email",
  ]
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  password_policy {
    minimum_length                   = 8
    password_history_size            = 0
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
  sign_in_policy {
    allowed_first_auth_factors = [
      "PASSWORD",
    ]
  }
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }
}

resource "aws_cognito_user_pool_client" "this" {
  name         = format("blogapi-miyamo-today-user-pool-client-%s", var.environment)
  user_pool_id = aws_cognito_user_pool.this.id
  token_validity_units {
    access_token  = "hours"
    id_token      = "days"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = format("blogapi-miyamo-today-%s", var.environment)
  user_pool_id = aws_cognito_user_pool.this.id
}