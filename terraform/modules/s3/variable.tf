variable "bucket_name" {
  type = string
}

variable "cloudfront_distribution_arn" {
  type = string
}

variable "allowed_origins" {
  type    = list(string)
  default = []
}
