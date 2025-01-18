module "route53" {
  source = "../modules/route53"

  route53_zone_id                         = "XXXXXXXXX"
  site_domain                             = "lwa-rr7.n13u.me"
  cloudfront_distribution__domain_name    = module.cloudfront.distribution_domain_name
  cloudfront_distribution__hosted_zone_id = module.cloudfront.distribution_hosted_zone_id
}