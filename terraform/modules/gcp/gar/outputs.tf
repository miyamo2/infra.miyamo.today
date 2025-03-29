output "credentials" {
  value     = base64decode(google_service_account_key.this.private_key)
  sensitive = true
}
