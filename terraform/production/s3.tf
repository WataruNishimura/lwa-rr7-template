module "s3_bucket" {
  source = "../modules/s3"

  bucket_name                 = "lwa-rr7-production"
  allowed_origins             = ["lwa-rr7.n13u.me"]
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
}
