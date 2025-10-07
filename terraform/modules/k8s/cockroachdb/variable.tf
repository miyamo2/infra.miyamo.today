variable "config_context" {
  type     = string
  nullable = false
}

variable "sql_user_name" {
  type      = string
  nullable  = false
  default   = "maxroach"
  sensitive = true
}
