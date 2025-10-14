variable "license_key" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "config_context" {
  type     = string
  nullable = false
}
