
output "s3_bucket_name" {
  description = "S3 bucket name"

  value = aws_s3_bucket.static_website_bucket.bucket
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"

  value = aws_cloudfront_distribution.static_website_distribution.domain_name
}

output "website_url" {
  description = "Website HTTPS URL"

  value = "https://${aws_cloudfront_distribution.static_website_distribution.domain_name}"
}
