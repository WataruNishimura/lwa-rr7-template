module "cloudfront" {
  source                    = "../modules/cloudfront"
  static_origin_domain_name = module.s3_bucket.domain_name
  static_origin_id          = module.s3_bucket.id
  geo_locations             = ["JP"]
  comment                   = ""
  env                       = "production"
  default_cetificate        = false
  basicauth_enabled         = true
  # This is insecure. You must not hardcode the password.
  basicauth_username  = "username"
  basicauth_password  = "password"
  aliases             = ["lwa-rr7.n13u.mem"]
  acm_certificate_arn = module.acm_certificate.arn
  lambda_origin_domain_name = module.lambda.function_url
}
