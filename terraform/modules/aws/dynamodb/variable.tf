variable "billing_mode" {
  type     = string
  nullable = false
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "write_capacity" {
  type    = number
  default = 1
}

variable "read_capacity" {
  type    = number
  default = 1
}

variable "article_id_event_id_index" {
  type = object({
    read_capacity  = number
    write_capacity = number
  })
  default = {
    read_capacity  = 1
    write_capacity = 1
  }
}

variable "point_in_time_recovery" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}

variable "ttl" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}

