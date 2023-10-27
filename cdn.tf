# Configuration du CDN (CloudFront)
resource "aws_cloudfront_distribution" "wordpress_cdn" {
  origin {
    domain_name = aws_instance.wordpress.private_ip
    origin_id   = "myec2-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  enabled = true
  default_cache_behavior {
    target_origin_id       = "myec2-origin"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
    #acm_certificate_arn            = "YOUR_CERTIFICATE_ARN"
    #ssl_support_method             = "sni-only" # ou "vip" si nécessaire
  }
  tags = var.aws_common_tag
}
