variable "sql_user_name" {
  type      = string
  nullable  = false
  default   = "maxroach"
  sensitive = true
}

variable "kubernetes_namespace" {
  type      = string
  nullable  = false
  sensitive = true
}
