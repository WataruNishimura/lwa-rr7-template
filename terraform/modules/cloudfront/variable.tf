variable "env" {
  type = string
}
variable "static_origin_domain_name" {
  type = string
}

variable "static_origin_id" {
  type = string
}

variable "geo_locations" {
  type = list(string)
  default = ["JP"]
}

variable "aliases" {
  type = list(string)
  default = []
}

variable "acm_certificate_arn" {
  type = string
  default = ""
}

variable "comment" {
  type = string
  default = ""
}

variable "default_cetificate" {
  type = bool
  default = true
}


variable "basicauth_enabled" {
  type = bool
  default = false
}
variable "basicauth_username" {
  type = string
}

variable "basicauth_password" {
  type      = string
  sensitive = true
}

variable "lambda_origin_domain_name" {
  type = string
}