resource "aws_cloudfront_origin_access_identity" "this" {}

resource "aws_cloudfront_function" "basicauth" {
  count   = var.basicauth_enabled ? 1 : 0
  name    = "${var.env}_basic_auth"
  runtime = "cloudfront-js-1.0"
  publish = true
  code = templatefile(
    "${path.module}/cloudfront_functions_src/basicauth.js",
    {
      authString = base64encode("${var.basicauth_username}:${var.basicauth_password}")
    }
  )
}

resource "aws_cloudfront_cache_policy" "lambda_origin" {
  name        = "lambda_origin_cache_policy_${var.env}"
  min_ttl     = 1
  max_ttl     = 100
  default_ttl = 50
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "lambda_origin" {
  name                              = "oac_lambda_${var.env}" 
  signing_protocol                  = "sigv4"
  signing_behavior                  = "always"
  origin_access_control_origin_type = "lambda"
}

resource "aws_cloudfront_origin_access_control" "s3_origin" {
  name                              = "oac_s3_${var.env}"
  signing_protocol                  = "sigv4"
  signing_behavior                  = "always"
  origin_access_control_origin_type = "s3"
}

resource "aws_cloudfront_distribution" "this" {

  origin {
    domain_name              = replace(replace(var.lambda_origin_domain_name, "https://", ""), "/", "")
    origin_id                = "LambdaOrigin"
    origin_access_control_id = aws_cloudfront_origin_access_control.lambda_origin.id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name              = var.static_origin_domain_name
    origin_id                = var.static_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_origin.id

  }

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_200"

  default_cache_behavior {
    target_origin_id       = "LambdaOrigin"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods         = ["HEAD", "GET", "OPTIONS"]
    cache_policy_id        = aws_cloudfront_cache_policy.lambda_origin.id


    dynamic "function_association" {
      for_each = var.basicauth_enabled && aws_cloudfront_function.basicauth[0].arn != "" ? [aws_cloudfront_function.basicauth[0]] : []
      content {
        event_type   = "viewer-request"
        function_arn = function_association.value.arn
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/assets/*"
    target_origin_id       = var.static_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/manifest.json"
    target_origin_id       = var.static_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/images/*"
    target_origin_id       = var.static_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }


  ordered_cache_behavior {
    path_pattern           = "/icons/*"
    target_origin_id       = var.static_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/favicon.ico"
    target_origin_id       = var.static_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/robots.txt"
    target_origin_id       = var.static_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/"
  }

  aliases = var.aliases
  comment = var.comment

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.geo_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.default_cetificate
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
  }
}

