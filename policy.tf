
# Create CloudFront access policy
data "aws_iam_policy_document" "cloudfront_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.static_website_bucket.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.static_website_distribution.arn
      ]
    }
  }
}

# Attach policy to S3 bucket
resource "aws_s3_bucket_policy" "cloudfront_policy" {
  bucket = aws_s3_bucket.static_website_bucket.id

  policy = data.aws_iam_policy_document.cloudfront_policy.json
}
