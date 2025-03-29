variable "project_id" {
  type      = string
  nullable  = false
  sensitive = true
}
variable "network_name" {
  type      = string
  nullable  = false
  sensitive = true
}
variable "subnet_name" {
  type      = string
  nullable  = false
  sensitive = true
}
variable "vpc_name" {
  type    = string
  default = "blogapi-miyamo-today-vpc"
}
