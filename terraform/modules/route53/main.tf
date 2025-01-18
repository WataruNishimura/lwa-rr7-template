
resource "aws_route53_record" "site" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.site_domain}"
  type = "A"

  alias {
    name = "${var.cloudfront_distribution__domain_name}"
    zone_id = "${var.cloudfront_distribution__hosted_zone_id}"
    evaluate_target_health = false
  }
}