variable "domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "A list of subject alternative names for the ACM certificate"
  type        = list(string)
  default     = []
}
