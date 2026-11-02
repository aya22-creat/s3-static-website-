
# Create S3 Bucket
resource "aws_s3_bucket" "static_website_bucket" {
  bucket_prefix = "cloudfront-meme-website-"

  tags = {
    Name        = "Static Meme Website"
    Environment = "Learning"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.static_website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Website files configuration
locals {
  website_files = fileset(
    "${path.module}/website_files",
    "**"
  )

  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    png  = "image/png"
    gif  = "image/gif"
    svg  = "image/svg+xml"
    webp = "image/webp"
    ico  = "image/x-icon"
  }
}

# Upload all files to S3
resource "aws_s3_object" "website_files" {
  for_each = toset(local.website_files)

  bucket = aws_s3_bucket.static_website_bucket.id

  key = each.value

  source = "${path.module}/website_files/${each.value}"

  etag = filemd5(
    "${path.module}/website_files/${each.value}"
  )

  content_type = lookup(
    local.mime_types,
    lower(element(reverse(split(".", each.value)), 0)),
    "application/octet-stream"
  )

  depends_on = [
    aws_s3_bucket_public_access_block.website
  ]
}
