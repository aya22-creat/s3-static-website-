
# Create Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "meme-website-oac"
  description                       = "OAC for private S3 website bucket"

  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "static_website_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  wait_for_deployment = true

  # S3 origin
  origin {
    domain_name = aws_s3_bucket.static_website_bucket.bucket_regional_domain_name

    origin_id = "s3_origin"

    origin_access_control_id = (
      aws_cloudfront_origin_access_control.oac.id
    )
  }

  # Cache behavior
  default_cache_behavior {
    target_origin_id = "s3_origin"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  # Geographic restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Default CloudFront SSL certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "Meme Website CloudFront"
  }
}
